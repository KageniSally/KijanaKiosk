# AI Governance Log — KijaniKiosk Capstone

## Purpose

This document records the use of AI assistance during the KijaniKiosk capstone project. ChatGPT was used to support the design of the Jenkins CI/CD pipeline, Kubernetes staging configuration, troubleshooting, and documentation.

AI-generated suggestions were treated as guidance rather than final solutions. All proposed configurations were reviewed against the existing KijaniKiosk repository and tested before being accepted.

### 1. Date

15th August 2026

### 2. AI Tool Used

ChatGPT

### 3. Task / Problem

The capstone required extending the existing KijaniKiosk system into a production-approaching deployment workflow.

The main requirements addressed with AI assistance were:

* Creating an isolated `kijani-staging` Kubernetes namespace.
* Configuring `kk-payments` for staging using environment-specific configuration.
* Reusing the same Deployment manifest for staging and production.
* Creating a Jenkins pipeline that deploys to staging automatically.
* Running a smoke test against the staging deployment.
* Ensuring the production approval gate is available only after the staging smoke test succeeds.
* Deploying the application to production after approval.


The Kubernetes configuration was designed around the separation of application deployment from environment-specific configuration:


### 4. What AI Produced

AI was used to suggest the overall Jenkins pipeline structure and Kubernetes configuration approach.

For Jenkins, AI suggested separating the deployment process into distinct stages:


AI also suggested using a shell-based smoke test to verify the staging application's health and a Jenkins `input` step to create the production approval gate.

For Kubernetes, AI suggested using a reusable Deployment manifest while keeping environment-specific values in separate ConfigMaps. This allowed staging and production to use the same application deployment definition while providing different configuration values such as `DB_HOST`.

---

### 5. What AI Got Wrong

The AI-generated suggestions were based partly on a generic Kubernetes and Jenkins structure and therefore could not be copied directly into the existing KijaniKiosk project.

For the Jenkins pipeline, the initial suggestion assumed that the application's health endpoint, Kubernetes service name, namespace, and exposed port matched the suggested smoke-test command. These values had to be checked against the actual KijaniKiosk Kubernetes configuration.

For Kubernetes, the suggested directory structure did not automatically match the existing repository. Applying it without review could have created duplicate manifests or unnecessarily changed components that had already been developed during previous weeks.

The suggested configuration values also required verification against the actual project environment. In particular, the staging `DB_HOST` could not simply be copied from a generic example because staging and production require different environment-specific values.

---

### 6. Human Review and Changes

The existing KijaniKiosk repository was reviewed before implementing the suggested changes.

The Kubernetes configuration was adapted to the existing project instead of replacing the previous Week 9 implementation. The staging namespace, Deployment, ConfigMap, service, and application configuration were checked against the actual repository.

The staging environment was configured separately from production, with a different `DB_HOST` while retaining the reusable Deployment manifest.

The Jenkins pipeline was also adapted to the actual Kubernetes environment. The correct namespace, service, port, and application health endpoint were verified before the smoke test was used.

The production approval stage was deliberately placed **after** the smoke test to ensure that a failed staging deployment cannot proceed to production.

---

### 7. Verification

The Jenkins pipeline was tested to verify the intended sequence:

The configuration was also checked to ensure that staging and production use different environment-specific database configuration.

---

### 8. Governance Controls Applied

**Human review and verification:**
AI-generated code and configuration were reviewed against the actual KijaniKiosk repository before implementation.

**Testing before acceptance:**
Suggested pipeline and Kubernetes changes were tested rather than accepted based solely on AI output.

**Configuration verification:**
Environment-specific values, Kubernetes resources, service names, namespaces, ports, and health endpoints were verified against the actual deployment.

**Security and data protection:**
Secrets, passwords, access tokens, and other sensitive credentials were not intentionally provided to the AI tool or committed to the repository.

---

## Final Assessment

AI assistance was useful for structuring the CI/CD workflow and suggesting a reusable Kubernetes configuration approach. However, the initial output contained generic assumptions that did not fully match the existing KijaniKiosk implementation.

Human review was therefore necessary to adapt the suggestions to the actual repository, Kubernetes resources, application endpoints, and environment configuration.

The final implementation was accepted only after the relevant configuration was reviewed and the deployment workflow was tested. This ensured that AI supported the engineering process without replacing developer judgment, testing, or responsibility for the final system.
