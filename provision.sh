#!/bin/bash

set -euo pipefail

echo "========================================"
echo " KijaniKiosk Production Provisioning"
echo "========================================"

# Expected dirty conditions found in pre-provisioning audit:
# - Service accounts (kk-api, kk-payments, kk-logs) already exist.
# - Group 'kijanikiosk' already exists.
# - /opt/kijanikiosk directory structure already exists.
# - config and shared/logs are owned by root.
# - ACLs are missing on config and shared/logs.
# - UFW is inactive.
# - No systemd services exist.
# - No package holds are configured.
# ==================================================
# Phase 1 - Pre-flight Checks
# ==================================================

echo
echo "========== Phase 1: Pre-flight Checks =========="

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Please run this script using sudo."
    exit 1
fi

echo "Running as root...PASS"

echo "Checking required commands..."

for cmd in getfacl setfacl ufw systemctl logrotate; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "PASS: $cmd found"
    else
        echo "FAIL: $cmd not installed"
        exit 1
    fi
done
# ==================================================
# Phase 2 - Users and Group
# ==================================================

echo
echo "========== Phase 2: Users and Group =========="

# Create group if it doesn't exist
if getent group kijanikiosk >/dev/null; then
    echo "PASS: Group 'kijanikiosk' already exists"
else
    groupadd kijanikiosk
    echo "PASS: Group 'kijanikiosk' created"
fi

# Create users if they don't exist
for user in kk-api kk-payments kk-logs
do
    if id "$user" >/dev/null 2>&1; then
        echo "PASS: User '$user' already exists"
    else
        useradd -m -g kijanikiosk "$user"
        echo "PASS: User '$user' created"
    fi
done

# Ensure all service users belong to the shared group
usermod -aG kijanikiosk kk-api
usermod -aG kijanikiosk kk-payments
usermod -aG kijanikiosk kk-logs

echo "PASS: Service users added to kijanikiosk group"
# ==================================================
# Phase 3 - Directories, Ownership and Permissions
# ==================================================

echo
echo "========== Phase 3: Directories, Ownership and Permissions =========="

# Ensure required directories exist
mkdir -p /opt/kijanikiosk/config
mkdir -p /opt/kijanikiosk/shared/logs
mkdir -p /opt/kijanikiosk/health

echo "PASS: Directory structure verified"

# Set ownership
chown root:kijanikiosk /opt/kijanikiosk
chown root:kijanikiosk /opt/kijanikiosk/config
chown kk-logs:kijanikiosk /opt/kijanikiosk/shared/logs
chown root:kijanikiosk /opt/kijanikiosk/health

echo "PASS: Ownership configured"

# Set permissions
chmod 755 /opt/kijanikiosk
chmod 750 /opt/kijanikiosk/config
chmod 2775 /opt/kijanikiosk/shared/logs
chmod 755 /opt/kijanikiosk/health

echo "PASS: Permissions configured"

# Remove existing ACLs
setfacl -b /opt/kijanikiosk/shared/logs

# Configure ACLs
setfacl -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
setfacl -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
setfacl -m u:kk-logs:rwx /opt/kijanikiosk/shared/logs

# Configure default ACLs
setfacl -d -m u:kk-api:rwx /opt/kijanikiosk/shared/logs
setfacl -d -m u:kk-payments:rx /opt/kijanikiosk/shared/logs
setfacl -d -m u:kk-logs:rwx /opt/kijanikiosk/shared/logs

echo "PASS: ACLs configured"

# ==================================================
# Phase 4 - Environment Files & systemd Units
# ==================================================

echo
echo "========== Phase 4: Environment Files =========="

# Remove obsolete environment file from older versions
rm -f /opt/kijanikiosk/config/payments.env

cat >/opt/kijanikiosk/config/api.env <<EOF
PORT=3001
LOG_DIR=/opt/kijanikiosk/shared/logs
EOF

cat >/opt/kijanikiosk/config/payments-api.env <<EOF
LOG_DIR=/opt/kijanikiosk/shared/logs
EOF

cat >/opt/kijanikiosk/config/logs.env <<EOF
LOG_DIR=/opt/kijanikiosk/shared/logs
EOF

chown root:kijanikiosk /opt/kijanikiosk/config/*.env
chmod 640 /opt/kijanikiosk/config/*.env

echo "PASS: Environment files created"

# ==================================================
# Phase 5 - systemd Units
# ==================================================

echo
echo "========== Phase 5: systemd Units =========="

cat >/etc/systemd/system/kk-api.service <<'EOF'
[Unit]
Description=KijaniKiosk API
After=network.target

[Service]
Type=simple
User=kk-api
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/api.env

ExecStart=/bin/bash -c 'while true; do sleep 60; done'

Restart=always
RestartSec=5

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes
ProtectSystem=strict
ProtectHome=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
LockPersonality=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes

[Install]
WantedBy=multi-user.target
EOF

echo "PASS: kk-api.service created"


########################################
# kk-payments.service
########################################

cat >/etc/systemd/system/kk-payments.service <<'EOF'
[Unit]
Description=KijaniKiosk Payments Service
After=kk-api.service
Wants=kk-api.service

[Service]
Type=simple
User=kk-payments
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/payments-api.env

ExecStart=/bin/bash -c 'while true; do sleep 60; done'

Restart=always
RestartSec=5

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes
ProtectSystem=strict
ProtectHome=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
ProtectClock=yes
ProtectHostname=yes
ProtectProc=invisible
ProcSubset=pid
LockPersonality=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes

[Install]
WantedBy=multi-user.target
EOF

echo "PASS: kk-payments.service created"
########################################
# kk-logs.service
########################################

cat >/etc/systemd/system/kk-logs.service <<'EOF'
[Unit]
Description=KijaniKiosk Logs Service
After=network.target

[Service]
Type=simple
User=kk-logs
Group=kijanikiosk
EnvironmentFile=/opt/kijanikiosk/config/logs.env

ExecStart=/bin/bash -c 'while true; do sleep 60; done'

Restart=always
RestartSec=5

NoNewPrivileges=yes
PrivateTmp=yes
PrivateDevices=yes
ProtectSystem=strict
ProtectHome=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
LockPersonality=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes

[Install]
WantedBy=multi-user.target
EOF

echo "PASS: kk-logs.service created"
# ==================================================
# Phase 6 - Firewall
# ==================================================

echo
echo "========== Phase 6: Firewall =========="

ufw --force reset

ufw default deny incoming
ufw default allow outgoing

ufw allow 22/tcp comment 'Allow SSH'
ufw allow 80/tcp comment 'Allow HTTP'

ufw allow from 127.0.0.1 to any port 3001 proto tcp comment 'Local API access'
ufw allow from 10.0.1.0/24 to any port 3001 proto tcp comment 'Monitoring subnet'

ufw deny 3001/tcp comment 'Block external access'

ufw --force enable

echo "PASS: Firewall configured"
echo
echo "Verifying firewall rules..."

failed=0
status=$(ufw status)

echo "$status" | grep -q "22/tcp.*ALLOW" \
    && echo "PASS: SSH rule present" \
    || { echo "FAIL: SSH rule missing"; ((failed++)); }

echo "$status" | grep -q "80/tcp.*ALLOW" \
    && echo "PASS: HTTP rule present" \
    || { echo "FAIL: HTTP rule missing"; ((failed++)); }

echo "$status" | grep -q "3001/tcp.*127.0.0.1" \
    && echo "PASS: Loopback access rule present" \
    || { echo "FAIL: Loopback rule missing"; ((failed++)); }

echo "$status" | grep -q "3001/tcp.*10.0.1.0/24" \
    && echo "PASS: Monitoring subnet rule present" \
    || { echo "FAIL: Monitoring subnet rule missing"; ((failed++)); }

echo "$status" | grep -q "3001/tcp.*DENY" \
    && echo "PASS: External deny rule present" \
    || { echo "FAIL: External deny rule missing"; ((failed++)); }

if [ "$failed" -eq 0 ]; then
    echo "PASS: Firewall verification completed"
else
    echo "FAIL: $failed firewall verification checks failed"
    exit 1
fi

# ==================================================
# Phase 7 - Journal Persistence
# ==================================================

echo
echo "========== Phase 7: Journal Persistence =========="

mkdir -p /var/log/journal

sed -i 's/^#*Storage=.*/Storage=persistent/' /etc/systemd/journald.conf

if grep -q "^SystemMaxUse=" /etc/systemd/journald.conf; then
    sed -i 's/^SystemMaxUse=.*/SystemMaxUse=500M/' /etc/systemd/journald.conf
else
    echo "SystemMaxUse=500M" >> /etc/systemd/journald.conf
fi

systemctl restart systemd-journald

echo "PASS: Journal persistence configured"
cat >/etc/logrotate.d/kijanikiosk <<'EOF'
/opt/kijanikiosk/shared/logs/*.log {
    su kk-logs kijanikiosk
    daily
    rotate 14
    compress
    missingok
    notifempty
    create 664 kk-api kijanikiosk
    sharedscripts
    postrotate
        systemctl try-restart kk-logs.service >/dev/null 2>&1 || true
    endscript
}
EOF

echo "PASS: Logrotate configuration created"

logrotate --debug /etc/logrotate.d/kijanikiosk >/dev/null

echo "PASS: Logrotate verification passed"

# ==================================================
# Phase 8 - Monitoring Health Checks
# ==================================================

echo
echo "========== Phase 8: Monitoring Health Checks =========="

api_status=$(timeout 2 bash -c "echo >/dev/tcp/127.0.0.1/3000" 2>/dev/null && echo '"ok"' || echo '"down"')

payments_status=$(timeout 2 bash -c "echo >/dev/tcp/127.0.0.1/3001" 2>/dev/null && echo '"ok"' || echo '"down"')

cat >/opt/kijanikiosk/health/last-provision.json <<EOF
{
  "timestamp":"$(date -Is)",
  "kk-api":$api_status,
  "kk-payments":$payments_status
}
EOF

chown kk-logs:kijanikiosk /opt/kijanikiosk/health/last-provision.json
chmod 640 /opt/kijanikiosk/health/last-provision.json

echo "PASS: Health check written"

echo
echo "========== Final Verification =========="

failed=0

systemctl is-enabled kk-api >/dev/null \
&& echo "PASS: kk-api enabled" \
|| { echo "FAIL: kk-api"; ((failed++)); }

systemctl is-enabled kk-payments >/dev/null \
&& echo "PASS: kk-payments enabled" \
|| { echo "FAIL: kk-payments"; ((failed++)); }

systemctl is-enabled kk-logs >/dev/null \
&& echo "PASS: kk-logs enabled" \
|| { echo "FAIL: kk-logs"; ((failed++)); }

test -f /opt/kijanikiosk/health/last-provision.json \
&& echo "PASS: Health JSON exists" \
|| { echo "FAIL: Health JSON missing"; ((failed++)); }

test -f /etc/logrotate.d/kijanikiosk \
&& echo "PASS: Logrotate config exists" \
|| { echo "FAIL: Logrotate config missing"; ((failed++)); }

if [ "$failed" -eq 0 ]; then
    echo
    echo "Provisioning completed successfully."
    exit 0
else
    echo
    echo "$failed verification checks failed."
    exit 1
fi
