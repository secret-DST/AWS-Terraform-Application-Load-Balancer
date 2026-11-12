# AWS Application Load Balancer with Terraform
## Architectural Diagram
<img width="846" height="581" alt="Screenshot 2026-08-18 192113" src="https://github.com/user-attachments/assets/c6ea4cd2-5ba2-4995-ad76-7df737f2e9e3" />

NOTE: The EC2 instances are deployed in different AZs 

## Overview
This project uses Terraform to provision an AWS infrastructure with an Application Load Balancer (ALB) and EC2 instances running Ubuntu.
The ALB distributes incoming HTTP traffic across instances to improve availability and traffic distribution.

## AWS Services Used
- **VPC** – Provides network isolation.
- **EC2** – Hosts the web application.
- **Application Load Balancer** – Distributes incoming traffic.
- **Target Group** – Registers EC2 instances and performs health checks.
- **Security Groups** – Controls inbound and outbound traffic.
- **Auto Scaling Group** – Maintains the desired number of EC2 instances.
- **Terraform** – Infrastructure as Code (IaC).

## Project Structure
```text
.
├── backend.tf
├── main.tf
├── provider.tf
├── var.tf
├── output.tf
├── target_group.tf
├── user_data.sh
└── .gitignore
```

## Deployment
- **terraform init** – initialises the directory
- **terraform fmt** - formats the code to make it more presentable/readable
- **terraform validate** – validates if correct syntax is used
- **terraform plan** – displays a preview of the resources- to be added, changes or destroyed
- **terraform apply** - applies the terraform configuration to target provider's infrastructure
  

After deployment, access the application using the ALB DNS name provided in the Terraform outputs.
To ensure the load balancer is operational, visit the application through the DNS of ALB and refresh the site. (multiple times if needed)
The site should alternate between 2 different hostnames. (EC2s)

## Cleanup

To remove the infrastructure:
- **terraform destroy** - destroys all infrastructure managed by terraform

