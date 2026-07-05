# Hardening Decisions for the KijaniKiosk Staging Environment

## Purpose

This document explains the security decisions made when designing the KijaniKiosk staging environment. The objective was to create a repeatable infrastructure that is secure by default while remaining easy for the engineering team to deploy and maintain. The infrastructure was provisioned using Terraform and configured using Ansible so that every server is built consistently without manual intervention.

The staging environment consists of three application servers: **API**, **Payments**, and **Logs**. Every deployment follows the same configuration process, reducing configuration drift and ensuring that future deployments remain predictable.

## Security Controls

| Control                              | What it does                                                                                                       | Risk mitigated                                                                          |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| Restricted SSH access                | SSH access is limited to trusted administrator IP addresses instead of being open to everyone.                     | Reduces the likelihood of unauthorized remote access and automated scanning.            |
| SSH key authentication               | Password authentication is disabled and administrators authenticate using SSH key pairs.                           | Prevents password guessing and brute-force attacks.                                     |
| Remote Terraform state               | Infrastructure state is stored in a remote backend with encryption enabled.                                        | Prevents accidental loss of state and supports collaborative infrastructure management. |
| State locking                        | State locking prevents multiple engineers from modifying infrastructure simultaneously.                            | Avoids state corruption and conflicting infrastructure changes.                         |
| Least privilege service accounts     | Each application runs under its own dedicated service account instead of the root user.                            | Limits the impact if an individual service is compromised.                              |
| Systemd service hardening            | Services use restrictive execution policies such as preventing privilege escalation and isolating temporary files. | Reduces the ability of compromised services to affect the operating system.             |
| Firewall configuration               | Only required network ports are exposed while unnecessary ports remain blocked.                                    | Reduces the external attack surface.                                                    |
| Log rotation and journal persistence | Logs are retained, rotated, and compressed automatically.                                                          | Prevents storage exhaustion while preserving security events for investigation.         |

## Infrastructure Security

Infrastructure is managed entirely as code. Every server, networking rule, and configuration change is stored in version control, allowing changes to be reviewed before deployment. This provides an audit trail and makes it possible to reproduce environments consistently.

The infrastructure is deployed through reusable Terraform modules. Instead of creating separate resource definitions for each server, a single reusable module provisions all application servers. This reduces duplication and minimizes the possibility of inconsistent configuration.

A remote Terraform backend stores the infrastructure state. Encrypting the state protects sensitive infrastructure metadata while centralized storage ensures the entire team works from the same source of truth. State locking prevents simultaneous updates that could otherwise leave the infrastructure in an inconsistent state.

Terraform retrieves the operating system image dynamically rather than relying on a fixed image identifier. This reduces maintenance effort and ensures supported operating system releases can be adopted without extensive code changes.

## Server Configuration

After infrastructure provisioning, Ansible configures every server from a clean operating system installation. This ensures every server receives identical configuration regardless of when it is deployed.

System packages are updated during provisioning and only the software required for the environment is installed. Removing unnecessary software reduces the number of components that require security updates and decreases the overall attack surface.

Dedicated service accounts are created for each application component. The API, Payments, and Logs services each run independently with only the permissions required for their specific function.

Configuration files are deployed from templates. This ensures all environments remain consistent while allowing values such as hostnames, ports, and application settings to change without modifying the deployment logic.

## Service Hardening

Application services are managed by systemd. Security directives are applied to restrict service capabilities and reduce the impact of compromise.

Privilege escalation is prevented by disabling the acquisition of additional privileges after service startup. Temporary directories are isolated so services cannot interfere with one another through shared temporary storage.

Sensitive operating system components are protected by preventing services from modifying critical system files. Services also have limited visibility into kernel interfaces and administrative resources.

Applications write only to directories explicitly required for normal operation. Restricting writable locations helps protect operating system files from accidental modification or malicious activity.

Services automatically restart after unexpected failures, improving availability while avoiding unnecessary manual intervention.

## Network Protection

Firewall rules allow only the network traffic required for operation. Administrative access is restricted to trusted sources while application traffic is limited to the necessary service ports.

Outbound communication remains available for software updates and required application connectivity. No unnecessary inbound services are exposed to the internet.

## Logging and Monitoring

Persistent logging ensures that important operational events remain available after system restarts. Automatic log rotation prevents log files from consuming excessive disk space while preserving historical information for troubleshooting.

Centralized logging also improves operational visibility by making it easier to investigate incidents and identify abnormal system behavior.

