# Sally Gitonga Capstone Project
## Kijani Kiosk End to End Delivery
### Tract Selected
**Track A — Infrastructure-First**

# KijaniKiosk

## 1. Project Overview

KijaniKiosk is an end-to-end DevOps capstone project focused on delivering a reliable and repeatable application environment using an **Infrastructure-First** approach.

The project demonstrates:

* Infrastructure as Code using Terraform
* Server configuration using Ansible
* CI/CD using Jenkins
* Container orchestration using Kubernetes
* Configuration management using ConfigMaps
* Application health checks using probes
* CPU and memory resource management
* Monitoring and operational visibility
* Serverless payment processing
* S3-based receipt storage
* Staging validation and production approval

The main goal is to demonstrate how an application can move from source code to production through a controlled, automated and reproducible delivery process.

---

## 2. Architecture



### Main Components

**GitHub** — Source control, version control and collaboration.

**Jenkins** — Automates the build, testing and deployment workflow.

**Terraform** — Defines and provisions infrastructure as code.

**Ansible** — Automates server configuration and installation tasks.

**Kubernetes** — Provides the runtime environment for application workloads.

**ConfigMaps** — Store environment-specific configuration separately from application images.

**Probes** — Readiness and liveness probes help Kubernetes determine whether containers are ready or need recovery.

**kk-payments** — Handles the serverless payment-processing component.

**Monitoring** — Provides visibility into application and infrastructure health.

**S3** — Provides persistent object storage for receipt artifacts.

---

## 3. Prerequisites

Before running the project locally, install:

* Git
* Docker
* Docker Compose
* Node.js and npm
* Terraform
* Ansible
* kubectl
* Kubernetes
* Jenkins

Verify the installations:

```bash
git --version
docker --version
docker compose version
node --version
npm --version
terraform --version
ansible --version
kubectl version --client
```

You should also have access to the required environment variables, development database, Kubernetes configuration and cloud credentials where applicable.

---

## 4. Repository Structure

A simplified repository structure is:

```text
kijanakiosk-devops-foundation/
│
├── week1/
├── week2/
├── week3/
├── week4/
├── week5/
│
├── terraform/
├── ansible/
│
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── ...
│
├── jenkins/
│   └── Jenkinsfile
│
├── docs/
│   ├── ai-governance-log.md
│   └── ...
│
├── docker/
└── README.md
```

The repository is organized around infrastructure, configuration, Kubernetes, CI/CD and project documentation.

---

## 5. Local Development

### Clone the Repository

```bash
git clone <repository-url>
cd kijanakiosk-devops-foundation
```

### Configure Environment Variables

Example:

```env
APP_ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_NAME=kijanakiosk
DB_USER=<username>
DB_PASSWORD=<password>
```

> Do not commit passwords, API keys or other secrets to GitHub.

### Run with Docker

```bash
docker compose build
docker compose up -d
docker ps
docker compose logs
docker compose down
```

---

## 6. Deployment

KijaniKiosk follows this deployment pipeline:

```text
GitHub
   ↓
Jenkins
   ↓
Build & Test
   ↓
Staging
   ↓
Smoke Test
   ↓
Manual Approval
   ↓
Production
```

### Infrastructure Deployment

```bash
terraform init
terraform plan
terraform apply
```

### Server Configuration

```bash
ansible-playbook -i inventory playbook.yml
```

### Kubernetes Deployment

```bash
kubectl apply -f k8s/
kubectl get deployments
kubectl get pods
kubectl get services
```

The deployment should be validated in staging before production promotion.

---

## 7. Testing and Troubleshooting

### Testing

Smoke tests are used to confirm that the application is running correctly before production approval.

Useful Kubernetes checks:

```bash
kubectl get pods
kubectl get deployments
kubectl get services
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Common Troubleshooting

#### Pod is Not Running

```bash
kubectl get pods
kubectl describe pod <pod-name>
```

Check events for scheduling, image, configuration or resource errors.

#### Container Keeps Restarting

```bash
kubectl logs <pod-name>
```

Check application errors, environment variables, database connectivity, resources and health probes.

#### Service is Not Accessible

```bash
kubectl get services
kubectl describe service <service-name>
```

Verify that the service selector matches the application pod labels.

#### Jenkins Deployment Fails

Check:

* Jenkins console output
* Git credentials
* Docker build errors
* Kubernetes credentials
* Environment variables
* Deployment configuration

---

## 8. Monitoring

Monitoring provides visibility into the health and behavior of the deployed system.

The monitoring approach focuses on:

* Application availability
* Container health
* Resource usage
* Deployment status
* Payment-processing activity
* Operational failures

Useful commands include:

```bash
kubectl get pods
kubectl top pods
kubectl get events
```

Kubernetes readiness and liveness probes provide automated health checks for application workloads.

---

## 9. AI Governance

AI was used as an assistant rather than as an authoritative source.

The governance workflow is:

```text
AI Task
   ↓
AI Output
   ↓
Problem / Error Identified
   ↓
Human Correction
   ↓
Verification
```

AI was useful for:

* Documentation drafts
* Explaining technical concepts
* Suggesting configuration approaches
* Assisting with troubleshooting

Generated output was reviewed against the actual project files, commands, requirements and runtime behavior.

### Principle

> AI-generated output must be reviewed, corrected and verified by a human before being accepted as part of the project.

Detailed AI usage and corrections are documented in:

```text
docs/ai-governance-log.md
```

---

## 10. Production Gaps

### Gap 1 — Single Kubernetes Cluster

**Risk:** Cluster failure could affect multiple environments.

**Remediation:** Use a separate production cluster with a managed control plane.

### Gap 2 — Secrets Management

**Risk:** Sensitive configuration may be difficult to rotate and manage securely.

**Remediation:** Adopt a managed secrets solution with rotation and least-privilege access.

### Gap 3 — Disaster Recovery

**Risk:** Infrastructure or data loss could result in a long recovery time.

**Remediation:** Implement automated backups, documented recovery procedures and regular restore testing.

### Gap 4 — Production Hardening

**Risk:** The environment may not yet include all enterprise-level security and resilience controls.

**Remediation:** Introduce stronger access controls, network policies, security scanning, centralized secrets management and continuous vulnerability assessment.

---

## Conclusion

KijaniKiosk demonstrates an **Infrastructure-First DevOps delivery approach**, connecting source control, automated CI/CD, infrastructure provisioning, configuration management, Kubernetes deployment, testing, monitoring and production governance.

The project also documents its technical trade-offs, AI usage and remaining production gaps to provide a realistic view of the system's current maturity and future improvement path.
