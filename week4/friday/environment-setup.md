# Environment Setup

## Project

**Project Name:** KijaniKiosk Infrastructure as Code (IaC) Pipeline

**Environment:** Staging

**Operating System:** Ubuntu 24.04 LTS (64-bit)

---

## Development Machine

| Component        | Version          |
| ---------------- | ---------------- |
| Operating System | Ubuntu 24.04 LTS |
| Git              | 2.43.x           |
| Docker           | 28.x             |
| Terraform        | 1.13.x           |
| AWS CLI          | 2.x              |
| Ansible          | 2.18.x           |
| Python           | 3.12.x           |
| OpenSSH          | 9.x              |

---

## AWS Services Used

* Amazon EC2
* Amazon VPC
* Amazon S3 (Remote Terraform State)
* Amazon DynamoDB (Terraform State Locking)
* IAM
* Security Groups

---

## Terraform

Terraform is used to provision the infrastructure.

### Provider

* HashiCorp AWS Provider

### Terraform Version

```text
Terraform v1.13.x
```

### Backend

Remote backend configured using:

* Amazon S3 bucket for state storage
* DynamoDB table for state locking

Example:

* Bucket: `kijanikiosk-tfstate`
* State File: `week4/friday/terraform.tfstate`
* DynamoDB Table: `terraform-state-lock`

---

## Ansible

Ansible is used to configure the EC2 instances after Terraform provisions them.

### Inventory

The inventory is generated automatically by `pipeline.sh` using Terraform outputs.

### Connection

* SSH User: `ubuntu`
* Authentication: EC2 Key Pair
* Python Interpreter: `/usr/bin/python3`

---

## Project Structure

```text
week4/
└── friday/
    ├── terraform/
    │   ├── backend.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── variables.tf
    │   └── modules/
    │       └── app_server/
    ├── ansible/
    │   ├── inventory.ini
    │   ├── kijanikiosk.yml
    │   ├── group_vars/
    │   ├── host_vars/
    │   └── templates/
    ├── pipeline.sh
    ├── hardening-decisions.md
    ├── environment-setup.md
    └── reflection.md
```

---

## Infrastructure Components

Three EC2 instances are provisioned:

| Server   | Purpose                              |
| -------- | ------------------------------------ |
| API      | Hosts the application API service    |
| Payments | Hosts the payment processing service |
| Logs     | Hosts centralized logging services   |

---

## Automation Workflow

The deployment process follows this sequence:

1. Terraform initializes the backend.
2. Terraform validates and provisions the infrastructure.
3. Terraform outputs the EC2 public IP addresses.
4. `pipeline.sh` generates the Ansible inventory.
5. Ansible connects to the servers over SSH.
6. The playbook installs packages, creates service accounts, deploys configuration templates, configures systemd services, enables firewall rules, and configures logging.

---

## Verification Commands

Terraform:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Ansible:

```bash
ansible all -m ping
ansible-playbook -i inventory.ini kijanikiosk.yml
```

Pipeline:

```bash
chmod +x pipeline.sh
./pipeline.sh
```

---

## Expected Results

Successful deployment should produce:

* Three EC2 instances running.
* Terraform state stored remotely in Amazon S3.
* Terraform state locking enabled through DynamoDB.
* Automatically generated Ansible inventory.
* Successful Ansible connectivity (`ping = pong`).
* Configured API, Payments, and Logs services.
* Firewall rules applied.
* Systemd services enabled.
* Persistent system logging configured.
* Log rotation configured.
* Repeatable deployments with no configuration drift on subsequent runs.

---

## Prerequisites

Before running the project, ensure the following are available:

* AWS account with appropriate IAM permissions.
* Existing EC2 Key Pair.
* AWS CLI configured using `aws configure`.
* Amazon S3 bucket created for Terraform state.
* DynamoDB table created for state locking.
* Internet connectivity to AWS services.
* SSH access to provisioned EC2 instances.


