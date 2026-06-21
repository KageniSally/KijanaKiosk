# kk-payments Hardening

## Objective

Reduce the service exposure reported by `systemd-analyze security` while ensuring the service remains operational.

---

## Starting Point

Initial unit file used only the basic service configuration.

Security exposure was significantly higher than the target.

---

## Hardening Steps

### Step 1

Added:

* NoNewPrivileges=yes

Result:

Prevented privilege escalation.

---

### Step 2

Added:

* PrivateTmp=yes
* PrivateDevices=yes

Result:

Isolated temporary storage and hardware devices.

---

### Step 3

Added:

* ProtectSystem=strict
* ProtectHome=yes

Result:

Made the operating system read-only for the service and blocked access to user home directories.

---

### Step 4

Added:

* ProtectProc=invisible
* ProcSubset=pid

Result:

Restricted visibility of other processes.

---

### Step 5

Added:

* CapabilityBoundingSet=CAP_SYS_TIME
* AmbientCapabilities=
* RestrictRealtime=yes

Result:

Removed unnecessary capabilities while maintaining successful service startup.

---

## Directives Considered but Not Applied

### PrivateNetwork=yes

Reason:

The payments service requires network communication with the API.

---

### RestrictAddressFamilies

Reason:

The service requires standard network sockets, making aggressive filtering unsuitable.

---

## Final Result

The payments service starts successfully after all hardening measures.

Security exposure was reduced substantially while preserving functionality.

The final unit file remains inline within the provisioning script as required by the assignment.

