terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

##################################################
# Latest Ubuntu 22.04 AMI
##################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################################################
# Security Group
##################################################

resource "aws_security_group" "kijanikiosk_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for KijaniKiosk servers"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-security-group"
    }
  )
}

##################################################
# Server Definitions
##################################################

locals {

  servers = {
    api = {
      role = "api"
    }

    payments = {
      role = "payments"
    }

    logs = {
      role = "logs"
    }
  }

}

##################################################
# EC2 Servers
##################################################

module "app_servers" {

  source = "./modules/app_server"

  for_each = local.servers

  server_name = each.key

  region = var.region

  instance_type = var.instance_type

  key_name = var.key_name

  ami_id = data.aws_ami.ubuntu.id

  subnet_id = var.subnet_id

  security_group_id = aws_security_group.kijanikiosk_sg.id

  tags = merge(
    var.common_tags,
    {
      Name        = each.key
      Role        = each.value.role
      Environment = var.environment
    }
  )
}