# Integration Notes

## Challenge A – ProtectSystem and Environment Files

### Conflict

The services required strict filesystem protection while still reading their environment files.

### Options Considered

* Move configuration into another location.
* Relax filesystem protection.
* Keep configuration under the application directory.

### Decision

The configuration remained under `/opt/kijanikiosk/config` with appropriate permissions and ACLs.

### Reason

This maintained strong filesystem protection while allowing services to read only their required configuration files.

---

## Challenge B – Monitoring Health File

### Conflict

The provisioning script creates the health report as root, but monitoring requires non-root read access.

### Options Considered

* Leave ownership as root.
* Make the file world-readable.
* Assign ownership to the logging service.

### Decision

The file is owned by **kk-logs** with group **kijanikiosk** and mode **640**.

### Reason

Monitoring users can read the report while preventing unauthorized modification.

---

## Challenge C – Logrotate and PrivateTmp

### Conflict

Log rotation can replace log files with incorrect ownership or permissions.

### Options Considered

* Disable PrivateTmp.
* Remove post-rotation handling.
* Configure logrotate correctly.

### Decision

Default ACLs and the logrotate **su** directive were used to preserve ownership and permissions.

### Reason

This keeps the logging service isolated while ensuring new log files inherit the correct ACLs.

---

## Challenge D – Dirty VM State

### Conflict

The provisioning script had to work correctly whether resources already existed or not.

### Options Considered

* Always recreate resources.
* Ignore existing resources.
* Detect existing state and converge.

### Decision

Every phase checks current state before making changes.

### Reason

The script remains idempotent and safely converges both clean and previously configured systems to the desired state.

