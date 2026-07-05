#!/bin/bash

set -euo pipefail

###############################################
# Configuration
###############################################

TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./ansible"

INVENTORY_FILE="$ANSIBLE_DIR/inventory.ini"
PLAYBOOK="$ANSIBLE_DIR/kijanikiosk.yml"

ANSIBLE_USER="ubuntu"
SSH_KEY="$HOME/.ssh/your-key.pem"

###############################################
# Terraform
###############################################

echo "========================================="
echo "Initializing Terraform..."
echo "========================================="

cd "$TERRAFORM_DIR"

terraform init

echo ""
echo "========================================="
echo "Formatting Terraform..."
echo "========================================="

terraform fmt

echo ""
echo "========================================="
echo "Validating Terraform..."
echo "========================================="

terraform validate

echo ""
echo "========================================="
echo "Planning Infrastructure..."
echo "========================================="

terraform plan

echo ""
echo "========================================="
echo "Applying Infrastructure..."
echo "========================================="

terraform apply -auto-approve

###############################################
# Read Outputs
###############################################

echo ""
echo "========================================="
echo "Reading Terraform Outputs..."
echo "========================================="

API_IP=$(terraform output -raw api_server_ip)
PAYMENTS_IP=$(terraform output -raw payments_server_ip)
LOGS_IP=$(terraform output -raw logs_server_ip)

cd ..

###############################################
# Generate Inventory
###############################################

echo ""
echo "========================================="
echo "Generating inventory.ini..."
echo "========================================="

cat > "$INVENTORY_FILE" <<EOF
[kijanikiosk]
api ansible_host=$API_IP
payments ansible_host=$PAYMENTS_IP
logs ansible_host=$LOGS_IP

[kijanikiosk:vars]
ansible_user=$ANSIBLE_USER
ansible_ssh_private_key_file=$SSH_KEY
ansible_python_interpreter=/usr/bin/python3
EOF

echo ""
echo "Inventory generated:"
echo ""

cat "$INVENTORY_FILE"

###############################################
# Test Connectivity
###############################################

echo ""
echo "========================================="
echo "Testing Ansible Connectivity..."
echo "========================================="

ansible all \
-i "$INVENTORY_FILE" \
-m ping

###############################################
# Run Playbook
###############################################

echo ""
echo "========================================="
echo "Running Playbook..."
echo "========================================="

ansible-playbook \
-i "$INVENTORY_FILE" \
"$PLAYBOOK"

###############################################
# Finished
###############################################

echo ""
echo "========================================="
echo "Pipeline completed successfully!"
echo "========================================="

echo ""
echo "Server IPs"
echo "----------"

echo "API      : $API_IP"
echo "Payments : $PAYMENTS_IP"
echo "Logs     : $LOGS_IP"

echo ""
echo "SSH Commands"
echo "------------"

echo "ssh -i $SSH_KEY ubuntu@$API_IP"
echo "ssh -i $SSH_KEY ubuntu@$PAYMENTS_IP"
echo "ssh -i $SSH_KEY ubuntu@$LOGS_IP"