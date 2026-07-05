# Reflection

## 1. At what point during the project did you discover that two requirements conflicted? Describe the conflict and what you learned from resolving it.

The most significant conflict emerged while integrating the hardened systemd configuration with the automated Ansible deployment. The payments service required a restrictive security posture using systemd hardening directives such as `ProtectSystem=strict`, while the deployment process also needed the application to read its environment configuration during startup. Initially, these objectives appeared incompatible because the service could no longer access configuration files stored in locations that had become read-only under the stricter security settings.

Resolving this issue required reconsidering both the directory structure and the ownership of application files rather than weakening the security configuration. The environment files were relocated to a dedicated application configuration directory with carefully controlled permissions, and the systemd unit was updated to explicitly allow access only to the directories required for normal operation.

This experience reinforced an important engineering principle: security controls should not simply be disabled when they interfere with functionality. Instead, the deployment should be redesigned so that the application operates correctly within the intended security boundaries. The result was a configuration that maintained a strong security posture while remaining fully functional and reproducible through Ansible.

---

## 2. Rewrite one sentence from the hardening document for a technical audience. What is lost and what is gained?

The executive version focuses on business impact and communicates the benefit in language that is easy for non-technical stakeholders to understand. It avoids implementation details and emphasizes risk reduction.

The technical version provides precise implementation details that another engineer can validate or reproduce. It explains how the security objective is achieved but assumes familiarity with Linux security concepts and systemd hardening directives.

The trade-off is that the executive version is more accessible, while the technical version is significantly more useful for implementation, troubleshooting, and peer review.

---

## 3. Looking at the complete pipeline, what is the single most fragile handoff? How could it be improved?

The most fragile handoff in the pipeline is the transition between Terraform infrastructure provisioning and Ansible configuration. Ansible depends entirely on Terraform providing accurate infrastructure outputs before configuration can begin. If instance creation is delayed, networking is not yet available, security group rules are incomplete, or the generated inventory contains outdated information, the entire configuration stage fails despite the infrastructure being partially deployed.

The current implementation reduces this risk by generating the Ansible inventory directly from Terraform outputs instead of maintaining static IP addresses. This eliminates manual updates and ensures that recreated infrastructure can be configured without editing inventory files.

In a production environment, I would further strengthen this handoff by introducing readiness validation before Ansible begins execution. Rather than assuming newly created instances are immediately available, the pipeline would verify that each instance is reachable via SSH and has completed cloud initialization. I would also replace a static inventory file with Terraform-generated dynamic inventory or integrate Ansible with an AWS inventory plugin so that infrastructure discovery occurs automatically.

These improvements would make the deployment more resilient to temporary provisioning delays, scaling events, and infrastructure recreation while reducing the amount of manual intervention required from operators.

---
