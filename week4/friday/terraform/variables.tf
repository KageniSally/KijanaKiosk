variable "region" {
  description = "AWS region where the infrastructure will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for all application servers."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS EC2 key pair used for SSH access."
  type        = string
}

variable "vpc_id" {
  description = "VPC where the infrastructure will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instances will be launched."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access the servers over SSH."
  type        = string
}

variable "project_name" {
  description = "Project name used for resource tagging."
  type        = string
  default     = "kijanikiosk"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "staging"
}

variable "common_tags" {
  description = "Common tags applied to all AWS resources."
  type        = map(string)
  default = {
    Project     = "KijaniKiosk"
    Environment = "Staging"
    ManagedBy   = "Terraform"
  }
}