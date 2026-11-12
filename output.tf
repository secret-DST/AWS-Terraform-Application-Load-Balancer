output "public-ec2-2a" {
  description = "public ec2 2a hostname"
  value       = aws_instance.public_2a.public_ip
}

output "public-ec2-2b" {
  description = "public ec2 2b hostname"
  value       = aws_instance.public_2b.public_ip
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_alb.demo_alb.dns_name
}