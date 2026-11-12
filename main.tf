# creates VPC
resource "aws_vpc" "demo" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Test-VPC"
  }
}

#creates internet gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-igw"
  }
}

# creates a subnet in the region + availability zone: eu-west-2a
resource "aws_subnet" "public_2a" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.subnet_cidr_2a
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-2a"
  }
}

# creates a subnet in the region + availability zone: eu-west-2b
resource "aws_subnet" "public_2b" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.subnet_cidr_2b
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-2b"
  }
}

# Creates a route table to route trffic to internet gateway
resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "demo-public-rt"
  }
}

resource "aws_route_table_association" "demo" {
  for_each = {
    public_2a = aws_subnet.public_2a.id
    public_2b = aws_subnet.public_2b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.demo_rt.id
}

# creates key-pair to ssh into ec2 instances
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "alb_demo_keys" {
  key_name   = "alb-demo-keys"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/alb-demo-keys.pem"
  file_permission = "0600"
}

# craetes ec2 instance in AZ 2a
resource "aws_instance" "public_2a" {
  subnet_id              = aws_subnet.public_2a.id
  ami                    = var.ami
  instance_type          = var.instance_type[0]
  key_name               = aws_key_pair.alb_demo_keys.key_name
  vpc_security_group_ids = [aws_security_group.public.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "Public EC2 2a"
  }
}

# craetes ec2 instance in AZ 2b
resource "aws_instance" "public_2b" {
  subnet_id              = aws_subnet.public_2b.id
  ami                    = var.ami
  instance_type          = var.instance_type[1]
  key_name               = aws_key_pair.alb_demo_keys.key_name
  vpc_security_group_ids = [aws_security_group.public.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "Public EC2 2b"
  }
}

# creates security group that allows ssh/http traffic to and from ec2 instances
resource "aws_security_group" "public" {
  name        = "public-ec2-sg"
  description = "public ec2 security group. (http/ssh)"
  vpc_id      = aws_vpc.demo.id

  # SSH
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic]

  }

  /*# HTTP
  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80            You dont need to include access over http directly to the ec2 as
    protocol    = "tcp"           they will be accessed through the ALB DNS for a more secure setup.
    cidr_blocks = [var.all_traffic]
  }*/

  # allow all outbound traffic
  egress {
    description = "enable all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic]
  }
  tags = {
    Name = "public-ec2-sg"
  }

}

