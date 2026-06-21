# Hardening Decisions

## Building a Secure Foundation for the KijaniKiosk Production Server

The objective of this work was to create a production server that is secure by default, repeatable to deploy, and straightforward to maintain. Rather than relying on manual configuration, the server is built using a provisioning script that applies the same security controls every time it runs. This approach reduces human error, makes deployments consistent, and provides confidence that every production server starts from the same known state.

A major design decision was to separate responsibilities between services. Each service operates under its own identity and receives only the permissions required to perform its job. This limits the impact of mistakes or security incidents because one service cannot freely access another service's resources. Restricting privileges in this way reduces the likelihood that a single compromise could affect the entire application.

Sensitive configuration information is protected through controlled access. Only the services that require specific configuration values are permitted to read them. Administrative users retain ownership of configuration, while application services receive only the minimum level of access necessary for operation. This protects confidential information from accidental exposure and supports a clear separation of operational responsibilities.

Application data is organised into dedicated locations with carefully managed permissions. Shared resources such as log files are protected using an access model that allows collaboration between services while preventing unrestricted access. Additional controls ensure that newly created files automatically inherit the correct permissions, reducing the risk that routine maintenance could accidentally weaken security over time.

Service isolation was another important decision. Each application component operates within a restricted execution environment that limits its ability to interact with the wider operating system. Temporary storage, hardware devices, and sensitive operating system resources are isolated from the services wherever practical. If an application experiences unexpected behaviour, these restrictions reduce the potential impact on the rest of the server.

The firewall was configured to express the intended security policy rather than simply reflecting historical changes. Only services that need to be accessible are exposed externally. Internal communication paths remain available where required, while sensitive interfaces are protected from direct external access. Every firewall rule includes an explanation so that future administrators can understand why it exists rather than guessing its purpose.

Operational reliability was considered alongside security. System logs are stored persistently to ensure that important diagnostic information survives system restarts. Automated log management prevents storage from growing without limit while preserving access permissions after log files are rotated. This helps ensure that monitoring and troubleshooting continue to function without manual intervention.

Continuous verification is built into the provisioning process. Rather than assuming each configuration step succeeds, the script checks the outcome of critical operations before completing. Services are verified, firewall rules are confirmed, log management is validated, and a structured health report is produced after every execution. This provides immediate evidence that the server reached its intended state and simplifies future maintenance.

No security solution is complete without acknowledging its limits. This implementation establishes a strong operating system foundation, but it does not replace secure application development, vulnerability management, network monitoring, or regular software updates. These operational activities remain essential for protecting the production environment over time.

| Control                     | What it does                                    | Risk mitigated                            |
| --------------------------- | ----------------------------------------------- | ----------------------------------------- |
| Separate service accounts   | Runs each service independently                 | Limits impact of service compromise       |
| Least privilege             | Grants only required permissions                | Prevents unnecessary access               |
| Environment file protection | Restricts access to configuration               | Reduces exposure of sensitive information |
| Access Control Lists (ACLs) | Provides controlled shared access               | Prevents accidental permission escalation |
| Service isolation           | Restricts interaction with the operating system | Reduces attack surface                    |
| Firewall policy             | Allows only intended network access             | Prevents unnecessary external exposure    |
| Persistent logging          | Preserves operational records                   | Supports investigation and auditing       |
| Automated log management    | Maintains storage and permissions               | Prevents logging failures                 |
| Continuous verification     | Confirms successful provisioning                | Detects configuration problems early      |

## Remaining Gaps

This security posture significantly improves the server's resilience, but it cannot protect against every threat. It does not defend against vulnerabilities within the application itself, compromised administrator credentials, malicious insiders, or previously unknown software flaws. Long-term security also depends on regular patching, continuous monitoring, vulnerability assessments, secure development practices, and periodic reviews of access permissions. These operational activities complement the foundation established by this provisioning process and remain necessary throughout the server's lifecycle.

