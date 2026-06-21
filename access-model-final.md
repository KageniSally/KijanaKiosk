# KijaniKiosk Access Model (Final)

## Purpose

The KijaniKiosk production server follows the principle of least privilege. Every service receives only the permissions required to perform its own function. Shared resources use Linux groups and Access Control Lists (ACLs) to allow controlled collaboration without granting unnecessary access.

---

## Service Accounts

| Service  | User        | Primary Role                |
| -------- | ----------- | --------------------------- |
| API      | kk-api      | Runs the application API    |
| Payments | kk-payments | Processes payment requests  |
| Logs     | kk-logs     | Manages application logging |

All three users are members of the shared **kijanikiosk** group.

---

## Directory Layout

```
/opt/kijanikiosk
├── config
├── shared
│   └── logs
└── health
```

### Configuration Directory

Purpose:

* Stores service environment files.
* Writable only by administrators.
* Readable only by the services that require each file.

Environment files include:

* api.env
* payments-api.env
* logs.env

ACLs allow only the required service account to read each file.

---

### Shared Logs Directory

Purpose:

Provides a common location for application logs.

Permissions:

* kk-api writes log files.
* kk-payments reads logs for audit and troubleshooting.
* kk-logs manages rotation and maintenance.

Default ACLs are configured so that new files created after log rotation inherit the correct permissions automatically.

This prevents permission failures after log files are rotated.

---

### Health Directory

Purpose:

Stores the provisioning health report.

```
last-provision.json
```

Ownership:

* Owner: kk-logs
* Group: kijanikiosk

Permissions:

* Owner: read/write
* Group: read
* Others: none

This allows monitoring processes to read health status without requiring administrative privileges.

---

## ACL Strategy

ACLs are used where standard UNIX permissions cannot express the required access model.

Benefits include:

* fine-grained read access
* controlled write access
* automatic inheritance through default ACLs
* compatibility with log rotation

---

## Log Rotation Interaction

Log rotation creates new log files during rotation.

The logrotate configuration creates replacement files while the directory's default ACLs automatically restore the required permissions.

Verification was performed by:

1. forcing a log rotation
2. creating a new file as kk-api
3. confirming successful write access

This confirms the access model survives log rotation without manual intervention.

---

## Security Principles Applied

* Least privilege
* Separation of duties
* Group-based shared access
* ACL inheritance
* Restricted configuration access
* Secure monitoring access

The resulting access model is repeatable, idempotent and suitable for automated provisioning.

