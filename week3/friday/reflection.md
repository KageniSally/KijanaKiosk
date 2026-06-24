# Reflection

## 1. At what point during the project did you discover that two requirements were in conflict? Describe the conflict and what you learned from resolving it.

The most significant conflict occurred while configuring the payments service. The service required strong system hardening while still needing access to its environment file. Initially, restrictive filesystem protection prevented the service from accessing the configuration correctly. Resolving this required balancing security with functionality by applying permissions and ACLs carefully instead of simply relaxing the security settings. This reinforced the importance of testing every hardening decision rather than assuming more restrictions always produce a better outcome.

---

## 2. The hardening decisions document is written for Nia. Rewrite one sentence from that document in the technical language you would use if writing it for Tendo instead. What is lost and what is gained in the translation?

**For Nia:**

"Each service operates under its own identity and receives only the permissions required to perform its job."

**For Tendo:**

"Each systemd unit runs under a dedicated non-root service account with least-privilege permissions enforced through UNIX ownership, supplementary groups, ACLs, and systemd sandboxing directives."

The business version communicates the security objective without requiring technical knowledge, making it suitable for management. The technical version provides implementation details that are useful for engineers but would distract a non-technical audience from the overall security outcome.

---

## 3. Looking at the provisioning script as a whole, what is the single most fragile part of it? What would you need to know about the target environment to make that part robust?

The firewall configuration is the most environment-dependent component of the provisioning script. The script assumes specific ports, services, and monitoring network ranges that are appropriate for the current deployment but may not apply to another environment. To make this more robust, I would parameterize network ranges, service ports, and deployment-specific settings through configuration files or deployment variables rather than embedding them directly in the script. This would allow the same provisioning logic to be reused across development, staging, and production environments without modification.

