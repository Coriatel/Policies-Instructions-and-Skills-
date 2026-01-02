# Hostinger VPS Security Baseline — Ubuntu

## Purpose

This document defines the **minimum security baseline** and **enhanced hardening** configurations for Ubuntu-based Hostinger VPS instances.

**Compliance Context**: Hostinger enforces strict anti-abuse policies. This baseline ensures your VPS meets security expectations and reduces suspension risk.

**Target OS**: Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS

---

## Table of Contents

1. [Minimum Secure Baseline](#minimum-secure-baseline)
2. [Enhanced Hardening](#enhanced-hardening)
3. [Security Verification](#security-verification)
4. [Compliance Checklist](#compliance-checklist)

---

## Minimum Secure Baseline

These configurations are **REQUIRED** for any Hostinger VPS. Failure to implement these increases suspension risk.

### 1. System Updates

**Requirement**: Keep system packages current with security patches.

```bash
# Update package lists
sudo apt update

# Upgrade all packages
sudo apt upgrade -y

# Enable automatic security updates
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

**Verification**:
```bash
# Check for pending updates
apt list --upgradable

# Verify unattended-upgrades is active
sudo systemctl status unattended-upgrades
```

**Frequency**: Weekly manual updates + automatic security patches

---

### 2. SSH Hardening (CRITICAL)

**Requirement**: SSH must use key-based authentication only. Password authentication is a critical vulnerability.

#### Step 1: Set Up SSH Keys

**On your local machine**:
```bash
# Generate key pair (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key to VPS
ssh-copy-id username@VPS_IP
```

#### Step 2: Disable Password Authentication

⚠️ **CONFIRM REQUIRED**: This will prevent password-based SSH login.

```bash
# Backup SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit config
sudo nano /etc/ssh/sshd_config
```

**Required settings**:
```
# Disable password authentication
PasswordAuthentication no

# Enable public key authentication
PubkeyAuthentication yes

# Disable root login
PermitRootLogin no

# Disable empty passwords
PermitEmptyPasswords no

# Limit authentication attempts
MaxAuthTries 3
```

**Test and apply**:
```bash
# Test config syntax
sudo sshd -t

# If no errors, restart SSH
# ⚠️ KEEP current session open, test in NEW terminal first
sudo systemctl restart sshd
```

**Verification** (in new terminal):
```bash
# Should work with key
ssh username@VPS_IP

# Should fail without key
ssh -o PubkeyAuthentication=no username@VPS_IP
# Expected: Permission denied
```

---

### 3. Firewall Configuration (CRITICAL)

**Requirement**: Only necessary ports should be open. Default deny policy required.

```bash
# Install UFW
sudo apt install ufw -y

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (CRITICAL: Do this BEFORE enabling firewall)
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS (if running web server)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
# ⚠️ CONFIRM REQUIRED: Firewall will activate
sudo ufw enable

# Verify status
sudo ufw status verbose
```

**Expected output**:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
```

**Verification**:
```bash
# List all open ports
sudo ss -tulpn

# Should only show allowed services
```

---

### 4. Fail2Ban (CRITICAL)

**Requirement**: Intrusion prevention must be active to block brute force attacks.

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit local config
sudo nano /etc/fail2ban/jail.local
```

**Minimum configuration**:
```ini
[DEFAULT]
# Ban for 1 hour
bantime = 3600

# Time window for counting retries
findtime = 600

# Max attempts before ban
maxretry = 3

# Email alerts (optional)
destemail = your@email.com
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
```

**Start and enable**:
```bash
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Verify running
sudo systemctl status fail2ban

# Check SSH jail
sudo fail2ban-client status sshd
```

**Verification**:
```bash
# View banned IPs
sudo fail2ban-client status sshd

# Expected output includes:
# Status for the jail: sshd
# |- Filter
# |  |- Currently failed: X
# |  |- Total failed:     Y
# |  `- File list:        /var/log/auth.log
# `- Actions
#    |- Currently banned: Z
#    |- Total banned:     W
#    `- Banned IP list:   [IP addresses]
```

---

### 5. Disable Unnecessary Services

**Requirement**: Minimize attack surface by disabling unused services.

```bash
# List all running services
sudo systemctl list-units --type=service --state=running

# Disable common unnecessary services (if not needed):

# Bluetooth (on VPS, not needed)
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth

# Print server (if not needed)
sudo systemctl disable cups
sudo systemctl stop cups

# Avahi daemon (if not needed)
sudo systemctl disable avahi-daemon
sudo systemctl stop avahi-daemon
```

**Verification**:
```bash
# List enabled services
sudo systemctl list-unit-files --state=enabled

# Review list, ensure only needed services are enabled
```

---

### 6. Secure Shared Memory

**Requirement**: Prevent privilege escalation via shared memory.

```bash
# Edit fstab
sudo nano /etc/fstab
```

**Add this line**:
```
tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0
```

**Apply**:
```bash
# Remount
sudo mount -o remount /run/shm

# Verify
mount | grep shm
# Should include noexec,nosuid
```

---

### 7. File Permissions (Web Files)

**Requirement**: Web files must not be world-writable.

```bash
# Set ownership (for Nginx/Apache)
sudo chown -R www-data:www-data /var/www/html

# Set directory permissions
sudo find /var/www/html -type d -exec chmod 755 {} \;

# Set file permissions
sudo find /var/www/html -type f -exec chmod 644 {} \;

# Secure wp-config.php (if WordPress)
sudo chmod 440 /var/www/html/wp-config.php
sudo chown www-data:www-data /var/www/html/wp-config.php
```

**Verification**:
```bash
# Check for world-writable files (should return empty)
sudo find /var/www/html -type f -perm -002

# Check for world-writable directories (should return empty)
sudo find /var/www/html -type d -perm -002
```

---

### 8. Disable Root Login (System-Wide)

**Requirement**: Root account should not be accessible directly.

```bash
# Lock root password
sudo passwd -l root

# Verify
sudo passwd -S root
# Should show: "L" (locked)
```

**Note**: You can still use `sudo -i` to get root shell when needed.

---

### 9. Configure Logging

**Requirement**: System logs must be enabled and rotated.

```bash
# Verify rsyslog is running
sudo systemctl status rsyslog

# Configure log rotation
sudo nano /etc/logrotate.d/rsyslog
```

**Ensure these settings**:
```
/var/log/syslog
/var/log/mail.log
/var/log/kern.log
/var/log/auth.log
{
    rotate 7
    daily
    missingok
    notifempty
    delaycompress
    compress
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
```

**Verification**:
```bash
# Test log rotation
sudo logrotate -d /etc/logrotate.d/rsyslog

# Check log files exist
ls -lh /var/log/auth.log /var/log/syslog
```

---

### 10. Time Synchronization

**Requirement**: Accurate time is critical for security (SSL, logs, fail2ban).

```bash
# Install and enable NTP
sudo apt install systemd-timesyncd -y

# Start time sync
sudo systemctl start systemd-timesyncd
sudo systemctl enable systemd-timesyncd

# Verify
timedatectl status
# Should show: "System clock synchronized: yes"
```

---

## Enhanced Hardening

These configurations provide **additional security** beyond the baseline. Recommended for production environments.

### 1. AppArmor (Mandatory Access Control)

```bash
# Install AppArmor utilities
sudo apt install apparmor-utils -y

# Verify AppArmor is enabled
sudo aa-status

# Set all profiles to enforce mode
sudo aa-enforce /etc/apparmor.d/*

# Check status
sudo aa-status
# Should show profiles in enforce mode
```

---

### 2. Kernel Hardening (sysctl)

```bash
# Edit sysctl config
sudo nano /etc/sysctl.d/99-security.conf
```

**Add these settings**:
```ini
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Log Martians
net.ipv4.conf.all.log_martians = 1

# Ignore ICMP ping requests (optional, may break monitoring)
# net.ipv4.icmp_echo_ignore_all = 1

# Ignore broadcast ICMP requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Enable TCP SYN cookies (DDoS protection)
net.ipv4.tcp_syncookies = 1

# Disable IPv6 (if not using)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

**Apply settings**:
```bash
sudo sysctl -p /etc/sysctl.d/99-security.conf

# Verify
sudo sysctl net.ipv4.conf.all.rp_filter
# Should return: 1
```

---

### 3. Two-Factor Authentication (SSH)

**Install Google Authenticator**:
```bash
sudo apt install libpam-google-authenticator -y

# Run setup as your user (not root)
google-authenticator
```

**Answer prompts**:
- Time-based tokens? **Yes**
- Update .google_authenticator? **Yes**
- Disallow multiple uses? **Yes**
- Rate limiting? **Yes**
- Window size: **3** (recommended)

**Configure PAM**:
```bash
sudo nano /etc/pam.d/sshd
```

**Add at the top**:
```
auth required pam_google_authenticator.so
```

**Configure SSH**:
```bash
sudo nano /etc/ssh/sshd_config
```

**Add/modify**:
```
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
```

**Restart SSH** (⚠️ CONFIRM REQUIRED):
```bash
sudo systemctl restart sshd
```

**Test**: Login should now require SSH key + TOTP code.

---

### 4. Intrusion Detection (AIDE)

```bash
# Install AIDE
sudo apt install aide -y

# Initialize database (takes 5-10 minutes)
sudo aideinit

# Move database to active location
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Run check
sudo aide --check

# Schedule daily checks
echo "0 5 * * * /usr/bin/aide --check" | sudo crontab -
```

---

### 5. Limit User Resources

**Prevent fork bombs and resource exhaustion**:

```bash
# Edit limits
sudo nano /etc/security/limits.conf
```

**Add**:
```
* hard nproc 1000
* soft nproc 1000
* hard nofile 4096
* soft nofile 4096
```

---

### 6. Secure MySQL/MariaDB

```bash
# Run security script
sudo mysql_secure_installation
```

**Answer prompts**:
- Set root password: **Yes** (use strong password)
- Remove anonymous users: **Yes**
- Disallow root login remotely: **Yes**
- Remove test database: **Yes**
- Reload privilege tables: **Yes**

**Bind to localhost only**:
```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

**Set**:
```
bind-address = 127.0.0.1
```

**Restart**:
```bash
sudo systemctl restart mysql
```

**Verification**:
```bash
# Should only show 127.0.0.1:3306
sudo netstat -tulpn | grep mysql
```

---

### 7. Malware Scanning (ClamAV)

```bash
# Install ClamAV
sudo apt install clamav clamav-daemon -y

# Update virus definitions
sudo freshclam

# Create weekly scan script
sudo nano /usr/local/bin/malware-scan.sh
```

**Script**:
```bash
#!/bin/bash
DATE=$(date +%Y%m%d)
LOG="/var/log/clamscan_$DATE.log"

clamscan -r -i --log="$LOG" /var/www/ /home/

if grep -q "Infected files: 0" "$LOG"; then
  echo "Scan clean"
else
  echo "MALWARE DETECTED! Check $LOG" | mail -s "Malware Alert" your@email.com
fi
```

**Make executable and schedule**:
```bash
sudo chmod +x /usr/local/bin/malware-scan.sh

# Add to crontab
sudo crontab -e
```

**Add**:
```cron
0 4 * * 0 /usr/local/bin/malware-scan.sh
```

---

### 8. WordPress-Specific Hardening

**If running WordPress**:

```bash
# Block PHP execution in uploads
sudo nano /etc/nginx/sites-available/default
```

**Add inside server block**:
```nginx
location ~* /wp-content/uploads/.*\.php$ {
    deny all;
}

# Disable XML-RPC (if not needed)
location = /xmlrpc.php {
    deny all;
}

# Protect wp-config.php
location = /wp-config.php {
    deny all;
}
```

**Restart Nginx**:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

**Disable file editing** (wp-config.php):
```php
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', true);
```

---

## Security Verification

### Automated Security Audit Script

```bash
# Create audit script
sudo nano /usr/local/bin/security-audit.sh
```

**Script content**:
```bash
#!/bin/bash
# VPS Security Audit Script

echo "=== VPS Security Audit ==="
echo ""

# 1. Check SSH config
echo "[1] SSH Security:"
grep -E "^PasswordAuthentication|^PermitRootLogin|^PubkeyAuthentication" /etc/ssh/sshd_config
echo ""

# 2. Check firewall
echo "[2] Firewall Status:"
sudo ufw status | head -5
echo ""

# 3. Check fail2ban
echo "[3] Fail2Ban Status:"
sudo fail2ban-client status sshd | grep -E "Currently banned|Total banned"
echo ""

# 4. Check for world-writable files in web root
echo "[4] World-Writable Files:"
COUNT=$(sudo find /var/www -type f -perm -002 2>/dev/null | wc -l)
echo "Found: $COUNT files (should be 0)"
echo ""

# 5. Check system updates
echo "[5] System Updates:"
apt list --upgradable 2>/dev/null | grep -c upgradable
echo ""

# 6. Check disk space
echo "[6] Disk Space:"
df -h / | tail -1
echo ""

# 7. Check MySQL binding
echo "[7] MySQL Binding:"
sudo netstat -tulpn | grep mysql | awk '{print $4}'
echo "(Should be 127.0.0.1:3306)"
echo ""

# 8. Check for suspicious processes
echo "[8] Resource Usage:"
ps aux --sort=-%mem | head -6
echo ""

# 9. Check failed SSH attempts (last 24h)
echo "[9] Failed SSH Attempts (last 24h):"
sudo grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l
echo ""

echo "=== Audit Complete ==="
```

**Make executable**:
```bash
sudo chmod +x /usr/local/bin/security-audit.sh

# Run audit
sudo /usr/local/bin/security-audit.sh
```

---

## Compliance Checklist

Use this checklist to verify security baseline compliance:

### Minimum Baseline (REQUIRED)

- [ ] System packages updated
- [ ] Automatic security updates enabled
- [ ] SSH key-based authentication configured
- [ ] SSH password authentication disabled
- [ ] Root SSH login disabled
- [ ] Firewall (UFW) active with default deny
- [ ] Only required ports open (22, 80, 443)
- [ ] Fail2Ban installed and active
- [ ] Fail2Ban protecting SSH (jail enabled)
- [ ] Unnecessary services disabled
- [ ] Shared memory secured (noexec, nosuid)
- [ ] Web files ownership correct (www-data)
- [ ] Web file permissions correct (755/644)
- [ ] No world-writable files in web root
- [ ] Root account locked
- [ ] Logging enabled and configured
- [ ] Log rotation configured
- [ ] Time synchronization active

### Enhanced Hardening (RECOMMENDED)

- [ ] AppArmor enabled and enforcing
- [ ] Kernel hardening applied (sysctl)
- [ ] Two-factor authentication configured (SSH)
- [ ] Intrusion detection installed (AIDE)
- [ ] User resource limits configured
- [ ] MySQL/MariaDB secured
- [ ] MySQL bound to localhost only
- [ ] Malware scanning scheduled (ClamAV)
- [ ] WordPress file editing disabled
- [ ] PHP execution blocked in uploads directory
- [ ] XML-RPC disabled (if not needed)

### Compliance Verification

- [ ] Security audit script runs without errors
- [ ] No malware detected in recent scans
- [ ] No active Hostinger compliance notices
- [ ] Backup system operational
- [ ] Monitoring alerts configured
- [ ] Incident response plan documented

---

## Related Documentation

- [VPS Operations Runbook](/docs/ops/HOSTINGER_VPS_RUNBOOK.md)
- [Malware Response Procedure](/docs/ops/HOSTINGER_MALWARE_RESPONSE.md)
- [WordPress Hardening Guide](/docs/ops/HOSTINGER_WORDPRESS_HARDENING.md)
- [AI Agent Safety Protocol](/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md)
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md)

---

**Last Updated**: 2025-12-31
