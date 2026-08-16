# Sally Gitonga Capstone Project
## Kijani Kiosk End to End Delivery
### Tract Selected
**Track A — Infrastructure-First**

The project focuses on extending KijaniKiosk into a multi-environment, monitored, production-approaching system using Infrastructure as Code, configuration management, Kubernetes, Jenkins CI/CD, monitoring, and the existing serverless receipt chain.



## Architecture Diagram
                 GitHub
                    │
                    │ merge to main
                    ▼
                 Jenkins
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
     Terraform             Ansible
          │                   │
          └─────────┬─────────┘
                    ▼
             Kubernetes
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
     Production            Staging
     namespace             namespace
          │                   │
          │              kk-payments
          │                   │
          │              smoke test
          │                   │
          │                   ▼
          │             S3 staging bucket
          │                   │
          │                   ▼
          │           Serverless receipt
          │                chain
          │
          ▼
       Production

