##################################################
# Server Public IPs
##################################################

output "api_server_ip" {
  description = "Public IP of the API server"
  value       = module.app_servers["api"].public_ip
}

output "payments_server_ip" {
  description = "Public IP of the Payments server"
  value       = module.app_servers["payments"].public_ip
}

output "logs_server_ip" {
  description = "Public IP of the Logs server"
  value       = module.app_servers["logs"].public_ip
}

##################################################
# Server Private IPs
##################################################

output "api_private_ip" {
  description = "Private IP of API server"
  value       = module.app_servers["api"].private_ip
}

output "payments_private_ip" {
  description = "Private IP of Payments server"
  value       = module.app_servers["payments"].private_ip
}

output "logs_private_ip" {
  description = "Private IP of Logs server"
  value       = module.app_servers["logs"].private_ip
}

##################################################
# Instance IDs
##################################################

output "instance_ids" {
  description = "EC2 Instance IDs"

  value = {
    api      = module.app_servers["api"].instance_id
    payments = module.app_servers["payments"].instance_id
    logs     = module.app_servers["logs"].instance_id
  }
}

##################################################
# SSH Commands
##################################################

output "ssh_commands" {
  description = "SSH commands for connecting to the servers"

  value = {
    api      = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.app_servers["api"].public_ip}"
    payments = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.app_servers["payments"].public_ip}"
    logs     = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.app_servers["logs"].public_ip}"
  }
}

##################################################
# Inventory Data
##################################################

output "ansible_inventory" {
  description = "Inventory information for Ansible"

  value = {
    api = {
      hostname = module.app_servers["api"].public_ip
      user     = "ubuntu"
    }

    payments = {
      hostname = module.app_servers["payments"].public_ip
      user     = "ubuntu"
    }

    logs = {
      hostname = module.app_servers["logs"].public_ip
      user     = "ubuntu"
    }
  }
}