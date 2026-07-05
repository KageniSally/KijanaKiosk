variable "server_name" {
  description = "Name of the application server."
  type        = string
}

variable "region" {
  description = "Cloud region where the server will be provisioned."
  type        = string
}

variable "instance_type" {
  description = "Virtual machine instance type."
  type        = string
}

variable "key_name" {
  description = "SSH key pair used to access the server."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the Ubuntu 22.04 image."
  type        = string
}

variable "subnet_id" {
  description = "Subnet where the instance will be created."
  type        = string
}

variable "security_group_id" {
  description = "Security group attached to the instance."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to the server."
  type        = map(string)
  default     = {}
}