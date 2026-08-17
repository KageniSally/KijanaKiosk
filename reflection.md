# KijaniKiosk — Project Reflection

## 1. Introduction

Working on the KijaniKiosk DevOps capstone project provided practical experience in designing and implementing an end-to-end DevOps delivery process.

The project followed an **Infrastructure-First** approach and brought together infrastructure provisioning, configuration management, CI/CD, containerization, Kubernetes, monitoring, testing and production governance.

The main lesson from the project was that successful DevOps delivery is not only about deploying an application. It also requires automation, consistency, monitoring, security, testing and continuous improvement.

---

## 2. What I Learned

### Infrastructure as Code

I learned how Terraform can be used to define infrastructure in a repeatable and automated way.

Instead of manually configuring infrastructure, infrastructure can be represented as code and managed through commands such as:

```bash
terraform init
terraform plan
terraform apply
```

This approach makes infrastructure easier to reproduce and maintain.

### Configuration Management

Using Ansible helped me understand how server configuration and installation tasks can be automated.

This reduces repetitive manual work and helps maintain consistency between environments.

### CI/CD

The project improved my understanding of how Jenkins can automate the software delivery process.

The pipeline follows a controlled flow:

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

I learned the importance of validating changes before promoting them to production.

### Kubernetes

Kubernetes was one of the most important areas of learning.

I gained practical understanding of:

* Deployments
* Pods
* Services
* ConfigMaps
* Resource management
* Readiness probes
* Liveness probes
* Application troubleshooting

Commands such as the following became useful when investigating deployment issues:

```bash
kubectl get pods
kubectl get deployments
kubectl get services
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

---

## 3. Challenges I Faced

One of the main challenges was understanding how the different DevOps technologies connect together.

Terraform, Ansible, Jenkins and Kubernetes each solve different problems, but they must work together as part of one delivery process.

Troubleshooting Kubernetes deployments was also challenging. Problems such as containers restarting, services not being accessible or configuration errors required checking logs, pod descriptions, services and deployment configuration.

Another challenge was understanding how to manage configuration and secrets without exposing sensitive information in source control.

These challenges helped me understand that DevOps requires both technical knowledge and systematic troubleshooting.

---

## 4. How I Solved Problems

I approached problems by breaking them down into smaller components.

For Kubernetes issues, I first checked the state of the resources:

```bash
kubectl get pods
kubectl get deployments
kubectl get services
```

I then used more detailed commands when necessary:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

For infrastructure issues, I used Terraform's planning and deployment workflow to identify configuration problems before applying changes.

I also relied on documentation, project requirements, testing and AI assistance when troubleshooting. However, AI-generated suggestions were reviewed and verified against the actual project environment before being accepted.

---

## 5. Importance of Testing and Monitoring

The project showed me that deployment alone does not mean that a system is working correctly.

Smoke testing provides an initial validation that the application is functioning before production approval.

Monitoring provides visibility into:

* Application availability
* Container health
* Resource usage
* Deployment status
* Payment-processing activity
* Operational failures

Health probes are also important because Kubernetes can automatically determine whether an application is ready to receive traffic or needs to be restarted.

---

## 6. AI Governance Reflection

AI was useful throughout the project for explaining technical concepts, assisting with troubleshooting and helping create documentation.

However, I learned that AI output should not automatically be treated as correct.

The process I followed was:

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

This reinforced the importance of human review.

AI can accelerate development and learning, but the developer remains responsible for understanding, testing and validating the final implementation.

---

## 7. Security and Production Readiness

The project also helped me understand the difference between a working development environment and a production-ready system.

Some identified production gaps include:

* A single Kubernetes cluster
* Limited secrets management
* Disaster recovery requirements
* Additional production hardening

These gaps demonstrate that production readiness requires more than simply getting an application deployed.

Future improvements would include stronger access controls, managed secrets, automated backups, restore testing, network policies, security scanning and vulnerability assessment.

---

## 8. Skills I Developed

Through KijaniKiosk, I strengthened my practical understanding of:

* Git and GitHub
* Terraform
* Ansible
* Jenkins
* Docker
* Kubernetes
* CI/CD pipelines
* Infrastructure as Code
* Configuration management
* Application monitoring
* Troubleshooting
* Deployment validation
* Production readiness
* AI-assisted development

The project also improved my ability to read errors, investigate system behavior and approach technical problems systematically.

---

## 9. What I Would Improve

If I continued developing the project, I would focus on improving production resilience and security.

I would prioritize:

1. Separating staging and production infrastructure.
2. Introducing a managed secrets solution.
3. Implementing automated backups.
4. Testing disaster recovery procedures.
5. Adding stronger security controls.
6. Expanding monitoring and alerting.
7. Improving automated testing in the CI/CD pipeline.
8. Introducing more comprehensive vulnerability scanning.

These improvements would make the system more suitable for a real production environment.

---

## 10. Overall Reflection

KijaniKiosk gave me a better understanding of how the different parts of DevOps work together.

Before the project, individual technologies such as Terraform, Jenkins and Kubernetes could be viewed as separate tools. Through the project, I learned how they can form one continuous delivery process.

The biggest takeaway is that DevOps is not simply about automation. It is about creating a reliable process for building, testing, deploying, monitoring and continuously improving software.

The project also showed me the importance of documentation, troubleshooting, security, human verification and production planning.

Overall, KijaniKiosk strengthened both my technical and problem-solving skills and gave me practical experience with an Infrastructure-First DevOps delivery approach.
