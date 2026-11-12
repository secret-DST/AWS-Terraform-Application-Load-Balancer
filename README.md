# AWS Application Load Balancer with Terraform
## Architectural Diagram
<img width="846" height="581" alt="Screenshot 2026-08-18 192113" src="https://github.com/user-attachments/assets/c6ea4cd2-5ba2-4995-ad76-7df737f2e9e3" />

NOTE: The EC2 instances are deployed in 2 different subnets and AZs for fault tolerance and because utilising the AWS ALB requires this.
(deploying in at least 2 subnet in different AZs)

## Overview
This project uses Terraform to provision an AWS infrastructure with an Application Load Balancer (ALB) and EC2 instances running Ubuntu.
The ALB distributes incoming HTTP traffic across instances to improve availability and traffic distribution.

## AWS Services Used
- **VPC** – Provides network isolation.
- **EC2** – Hosts the web application.
- **S3** – remote backend to store terraform state.
- **Application Load Balancer** – Distributes incoming traffic.
- **Target Group** – Registers EC2 instances and performs health checks.
- **Security Groups** – Controls inbound and outbound traffic.
- **Auto Scaling Group** – Maintains the desired number of EC2 instances.
- **Terraform** – Infrastructure as Code (IaC).

## Project Structure
```text
.
├── backend.tf
├── provider.tf
├── main.tf
├── target_group.tf
├── var.tf
├── output.tf
├── user_data.sh
└── .gitignore
```

## Terraform state store
- Since we are working with AWS, we will leverage S3 to store our terraform state file. This is because storing our terraform state file
  remotely is much more secure than keeping it locally. Human error, accidental deletion are also risks associated with storing it locally.
  In addition, storing it remotely will enable seamless collaboration as any other entity working on the same terraform project can
  access it - with the right controls and access.

- Previously, DynamoDB was utilised alongside S3 to provide state locking, to prevent concurrent operations, which could result in corrupting
  the state file. However, terraform has made this process more convenient by providing state locking through "use_lockfile = true" configuration.
  Therefore, we will only be utilising S3 with the built in configuration, rather than the deprecated DynamoDB method.
  (The configuration for this process is in backend.tf)

## User data script
- The bash script in "user_data.sh" is a simple but fault-proof configuration for the ec2 instances we deploy in across the subnets.
  It creates a simple Apache 2 web server, that displays the hostname of each EC2 instance. (So we can visible see the ALB distributing traffic)

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

