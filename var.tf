variable "all_traffic" {
  description = "allows all traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "cidr block of vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_2a" {
  description = "cidr of subnet 2a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_2b" {
  description = "cidr of subnet 2b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "ami type ubuntu"
  type        = string
  default     = "ami-0224ce6f9504665ee"
}

variable "instance_type" {
  description = "instance type for public ec2:"
  type        = list(string)
  default     = ["t2.micro", "t3.micro"]
}