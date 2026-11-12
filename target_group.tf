# Creates the Target Group
resource "aws_alb_target_group" "web_tg" {
  name     = "demo-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Demo Web Target Gruop"
  }
}

# Include as pending/register instances with the target group
resource "aws_alb_target_group_attachment" "targets" {
  for_each = {
    public_2a = aws_instance.public_2a.id
    public_2b = aws_instance.public_2b.id
  }

  target_group_arn = aws_alb_target_group.web_tg.arn
  target_id        = each.value
  port             = 80
}

# security group for application load balancer

resource "aws_security_group" "alb_sg" {
  name        = "demo-alb-sg"
  description = "allow HTTP traffic to the ALB"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.all_traffic]
  }

  tags = {
    Name = "ALB Security Group"
  }
}

# Create the application load balancer
resource "aws_alb" "demo_alb" {
  name               = "demo-alb"
  internal           = false # Makes it internet facing
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_2a.id,
    aws_subnet.public_2b.id
  ]

  tags = {
    Name = "Demo ALB"
  }
}

# Allow http traffic from ALB to the EC2 instances
resource "aws_vpc_security_group_ingress_rule" "alb_to_ec2" {
  security_group_id            = aws_security_group.public.id
  referenced_security_group_id = aws_security_group.alb_sg.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  description = "Allow http from APLB to EC2"
}

# Listen on HTTP port 80 and forward requests to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_tg.arn
  }
}