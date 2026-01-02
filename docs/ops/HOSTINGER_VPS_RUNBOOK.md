# Hostinger VPS Operations Runbook

## Purpose

This runbook provides step-by-step procedures for safely operating a Hostinger VPS while ensuring compliance with their Terms of Service and avoiding suspension risks.

**Target Audience**: DevOps, developers, and AI agents operating Hostinger VPS instances.

**Core Principle**: Defensive security only. No abuse, no evasion, no offensive tools.

---

## Table of Contents

1. [Pre-Flight Checks](#pre-flight-checks)
2. [Fresh VPS Initial Setup](#fresh-vps-initial-setup)
3. [SSH Hardening](#ssh-hardening)
4. [Firewall Configuration](#firewall-configuration)
5. [WordPress Deployment](#wordpress-deployment)
6. [Cloudflare Integration](#cloudflare-integration)
7. [Backup Automation](#backup-automation)
8. [Monitoring Setup](#monitoring-setup)
9. [Incident Response](#incident-response)
10. [Ongoing Maintenance](#ongoing-maintenance)
11. [Emergency Contacts](#emergency-contacts)

---

## Pre-Flight Checks

Before starting any VPS operation:

- [ ] Confirm VPS is provisioned and accessible via Hostinger panel
- [ ] Verify you have root credentials or SSH key access
- [ ] Check current VPS status (no active suspension notices)
- [ ] Review Hostinger support tickets for any warnings
- [ ] Ensure local machine has SSH client installed
- [ ] Have password manager ready for credential storage

**Safety Note**: Never proceed if there's an active compliance notice from Hostinger. Address that first.

---

## Fresh VPS Initial Setup

### Step 1: First Login

```bash
# From local machine
ssh root@YOUR_VPS_IP

# ⚠️ FIRST TIME: Verify SSH fingerprint
# Compare with fingerprint shown in Hostinger panel
```

### Step 2: Update System

```bash
# Update package lists
sudo apt update

# Upgrade all packages
sudo apt upgrade -y

# Check if reboot needed
[ -f /var/run/reboot-required ] && echo "Reboot required"

# If reboot required:
# ⚠️ CONFIRM REQUIRED: Reboot will disconnect SSH
sudo reboot
# Wait 2-3 minutes, then reconnect
```

### Step 3: Create Non-Root Admin User

```bash
# Create user (replace 'adminuser' with your choice)
sudo adduser adminuser

# Add to sudo group
sudo usermod -aG sudo adminuser

# Verify sudo access
sudo -l -U adminuser
```

### Step 4: Set Up SSH Keys

**On your local machine** (not VPS):

```bash
# Generate SSH key pair if you don't have one
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key to VPS (replace adminuser and IP)
ssh-copy-id adminuser@YOUR_VPS_IP

# Test key-based login
ssh adminuser@YOUR_VPS_IP
# Should login without password
```

**Checkpoint**: You should now be able to SSH as adminuser without password.

---

## SSH Hardening

**⚠️ WARNING**: These changes will disable password authentication. Ensure SSH keys work first!

### Minimum Secure Baseline

```bash
# Backup SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

**Required changes**:
```
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
PermitEmptyPasswords no
```

**Test config syntax**:
```bash
sudo sshd -t
# Should output: no errors
```

**Apply changes** (⚠️ CONFIRM REQUIRED):
```bash
# Restart SSH service
sudo systemctl restart sshd

# ⚠️ DO NOT close current SSH session yet!
# Open NEW terminal and test login:
ssh adminuser@YOUR_VPS_IP
# If successful, close old session
```

### Enhanced Hardening (Optional)

```bash
# Additional SSH config options
sudo nano /etc/ssh/sshd_config
```

**Add these lines**:
```
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers adminuser
Protocol 2
```

**Change SSH port** (optional, adds obscurity):
```
Port 2222  # Choose non-standard port
```

**If changing port**:
- [ ] Update firewall rules BEFORE restarting SSH
- [ ] Document new port in password manager
- [ ] Test new port works before closing session

---

## Firewall Configuration

### Install and Configure UFW

```bash
# Install UFW
sudo apt install ufw -y

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (IMPORTANT: Do this BEFORE enabling firewall!)
sudo ufw allow 22/tcp
# Or if you changed SSH port:
# sudo ufw allow 2222/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Review rules before enabling
sudo ufw show added
```

**Enable firewall** (⚠️ CONFIRM REQUIRED):
```bash
# This will activate firewall
sudo ufw enable

# Verify status
sudo ufw status verbose
```

**Expected output**:
```
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
```

### Install Fail2Ban

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit local config
sudo nano /etc/fail2ban/jail.local
```

**Recommended settings**:
```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = 22
# Or your custom SSH port
```

**Start and enable**:
```bash
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status sshd
```

---

## WordPress Deployment

See detailed guide: `/docs/ops/HOSTINGER_WORDPRESS_HARDENING.md`

**Quick checklist**:
- [ ] LEMP stack installed (Nginx, MariaDB, PHP)
- [ ] Database created with strong password
- [ ] WordPress downloaded from official source
- [ ] File permissions set correctly (755/644)
- [ ] wp-config.php secured (440 permissions)
- [ ] PHP execution blocked in uploads directory
- [ ] Default admin username changed
- [ ] Security plugin installed (Wordfence)
- [ ] Backup plugin installed (UpdraftPlus)
- [ ] Auto-updates enabled

---

## Cloudflare Integration

### Add Site to Cloudflare

**In Cloudflare Dashboard**:
1. Click "Add a Site"
2. Enter your domain name
3. Select free plan
4. Review DNS records (Cloudflare auto-scans)
5. Update nameservers at your domain registrar

**DNS Configuration**:
- [ ] A record pointing to VPS IP (orange cloud = proxied)
- [ ] AAAA record if IPv6 (optional)
- [ ] CNAME for www pointing to domain

### SSL/TLS Configuration

**In Cloudflare**:
- SSL/TLS mode: **Full (strict)**
- Edge Certificates: Enabled
- Minimum TLS Version: **1.2**
- Automatic HTTPS Rewrites: Enabled

**On VPS** (install origin certificate):
```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Test auto-renewal
sudo certbot renew --dry-run
```

### Security Settings (Cloudflare)

- [ ] Security Level: Medium or High
- [ ] Bot Fight Mode: Enabled
- [ ] Browser Integrity Check: Enabled
- [ ] Challenge Passage: 30 minutes

### Firewall Rules (Cloudflare)

**Protect admin panel**:
- Rule: `(http.request.uri.path contains "/wp-admin" and ip.geoip.country ne "IL")`
- Action: Challenge
- (Adjust country code as needed)

---

## Backup Automation

### Database Backup Script

```bash
# Create backup directory
sudo mkdir -p /var/backups/mysql
sudo chown adminuser:adminuser /var/backups/mysql

# Create backup script
nano ~/backup-db.sh
```

**Script content**:
```bash
#!/bin/bash
# Database backup script

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/mysql"
DB_NAME="wordpress_db"
DB_USER="wordpress_user"
DB_PASS="YOUR_DB_PASSWORD"  # Store securely or use .my.cnf

mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_DIR/db_backup_$DATE.sql.gz"

# Keep only last 7 days
find "$BACKUP_DIR" -name "db_backup_*.sql.gz" -mtime +7 -delete

echo "Database backup completed: db_backup_$DATE.sql.gz"
```

**Make executable**:
```bash
chmod +x ~/backup-db.sh

# Test manually
~/backup-db.sh
```

### Files Backup Script

```bash
# Create backup script
nano ~/backup-files.sh
```

**Script content**:
```bash
#!/bin/bash
# WordPress files backup

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/files"
WP_DIR="/var/www/html"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/wp_files_$DATE.tar.gz" "$WP_DIR"

# Keep only last 4 weeks
find "$BACKUP_DIR" -name "wp_files_*.tar.gz" -mtime +28 -delete

echo "Files backup completed: wp_files_$DATE.tar.gz"
```

**Make executable**:
```bash
chmod +x ~/backup-files.sh
```

### Schedule with Cron

```bash
# Edit crontab
crontab -e
```

**Add these lines**:
```cron
# Database backup daily at 2 AM
0 2 * * * /home/adminuser/backup-db.sh >> /var/log/backup-db.log 2>&1

# Files backup weekly on Sunday at 3 AM
0 3 * * 0 /home/adminuser/backup-files.sh >> /var/log/backup-files.log 2>&1
```

### Offsite Backup (Recommended)

**Option 1: rsync to remote server**:
```bash
# Copy backups to remote server
rsync -avz /var/backups/ user@remote-server:/path/to/backups/
```

**Option 2: Upload to cloud storage** (S3, Google Drive, etc.)
- Install rclone or use cloud provider CLI
- Configure encrypted storage
- Schedule automated sync

---

## Monitoring Setup

### System Monitoring

**Install monitoring tools**:
```bash
sudo apt install htop iotop nethogs -y
```

**Check disk space**:
```bash
# Add to crontab for daily alerts
0 9 * * * df -h | grep -E "([8-9][0-9]|100)%" && echo "Disk space critical on $(hostname)" | mail -s "Disk Alert" your@email.com
```

### Log Monitoring

**Check failed SSH attempts**:
```bash
# Daily check
sudo tail -100 /var/log/auth.log | grep "Failed password"

# Count failed attempts
sudo grep "Failed password" /var/log/auth.log | wc -l
```

**Check Fail2Ban status**:
```bash
# See banned IPs
sudo fail2ban-client status sshd

# Unban IP if needed (false positive)
sudo fail2ban-client set sshd unbanip IP_ADDRESS
```

### Malware Scanning

**Install ClamAV**:
```bash
sudo apt install clamav clamav-daemon -y

# Update virus definitions
sudo freshclam

# Create scan script
nano ~/malware-scan.sh
```

**Scan script**:
```bash
#!/bin/bash
# Weekly malware scan

DATE=$(date +%Y%m%d)
LOG="/var/log/clamscan_$DATE.log"

# Scan web directories only (full scan is heavy)
clamscan -r -i --log="$LOG" /var/www/

# Alert if malware found
if grep -q "Infected files: 0" "$LOG"; then
  echo "Scan clean"
else
  echo "MALWARE DETECTED! Check $LOG" | mail -s "Malware Alert" your@email.com
fi
```

**Schedule weekly scan** (off-hours):
```bash
crontab -e
```

Add:
```cron
# Malware scan every Sunday at 4 AM
0 4 * * 0 /home/adminuser/malware-scan.sh
```

### Uptime Monitoring (External)

Use external service (recommendations):
- UptimeRobot (free tier available)
- Pingdom
- StatusCake
- Cloudflare Health Checks

**Configuration**:
- Monitor: HTTP/HTTPS on your domain
- Check interval: 5 minutes
- Alert: Email when down

---

## Incident Response

### When Hostinger Sends Compliance Notice

**IMMEDIATE ACTIONS** (freeze all normal work):

1. **Acknowledge promptly** (reply within hours):
   ```
   Subject: Re: [Ticket #XXXXX] Compliance Notice

   Hello Hostinger Support,

   I acknowledge receipt of your compliance notice regarding [issue].
   I am investigating immediately and will provide a full report within 24 hours.

   Current status: Investigation in progress.

   Best regards,
   [Your Name]
   ```

2. **Create VPS snapshot** (via Hostinger panel):
   - Login to hPanel
   - Go to VPS → Snapshots
   - Create snapshot (preserves evidence)

3. **Collect logs**:
   ```bash
   # Backup all logs
   sudo tar -czf /tmp/logs_$(date +%Y%m%d_%H%M%S).tar.gz /var/log/

   # List recently modified files
   find /var/www -type f -mtime -7 -ls > /tmp/recent_files_$(date +%Y%m%d).txt

   # Document running processes
   ps auxf > /tmp/processes_$(date +%Y%m%d).txt

   # Network connections
   netstat -tulpn > /tmp/netstat_$(date +%Y%m%d).txt
   ```

4. **Follow malware response procedure**: See `/docs/ops/HOSTINGER_MALWARE_RESPONSE.md`

5. **Document everything**: Create incident report in `/home/adminuser/incidents/`

6. **Respond to Hostinger with detailed report**:
   - What was found
   - Root cause identified
   - Actions taken
   - Vulnerability patched
   - Credentials rotated
   - Request rescan

### When Website is Down

```bash
# Check web server status
sudo systemctl status nginx

# Check error logs
sudo tail -50 /var/log/nginx/error.log

# Check disk space
df -h

# Check memory
free -m

# Restart web server if needed (⚠️ CONFIRM REQUIRED in production)
sudo systemctl restart nginx

# Check database
sudo systemctl status mysql
```

### When Performance Degraded

```bash
# Check CPU and memory
htop

# Check disk I/O
iotop

# Check network usage
nethogs

# Review slow queries (MySQL)
sudo tail -50 /var/log/mysql/mysql-slow.log

# Clear WordPress cache (if caching plugin installed)
sudo -u www-data wp cache flush --path=/var/www/html
```

---

## Ongoing Maintenance

### Daily Tasks (5 minutes)

```bash
# Quick health check script
nano ~/daily-check.sh
```

**Script**:
```bash
#!/bin/bash
echo "=== Daily VPS Health Check ==="
echo ""
echo "Disk Space:"
df -h | grep -E "/$|/var"
echo ""
echo "Memory:"
free -h | grep Mem
echo ""
echo "Failed SSH (last 24h):"
sudo grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l
echo ""
echo "Fail2Ban Banned IPs:"
sudo fail2ban-client status sshd | grep "Banned"
echo ""
echo "Nginx Status:"
sudo systemctl is-active nginx
echo ""
echo "MySQL Status:"
sudo systemctl is-active mysql
```

Run daily:
```bash
chmod +x ~/daily-check.sh
~/daily-check.sh
```

### Weekly Tasks (30 minutes)

- [ ] Review `/var/log/auth.log` for anomalies
- [ ] Check WordPress updates (core, plugins, themes)
- [ ] Review Cloudflare analytics and security events
- [ ] Check backup completion (verify files exist)
- [ ] Test website functionality
- [ ] Review fail2ban banned IPs (unban false positives)

### Monthly Tasks (2 hours)

- [ ] Full system update: `sudo apt update && sudo apt upgrade -y`
- [ ] Test backup restore (to staging environment)
- [ ] Rotate non-critical passwords
- [ ] Review user accounts and access levels
- [ ] Security scan with ClamAV (if not automated)
- [ ] Review and clean old log files
- [ ] Check SSL certificate expiry (should auto-renew via certbot)
- [ ] Review firewall rules for needed changes

### Quarterly Tasks (4 hours)

- [ ] Full security audit
- [ ] Rotate all credentials (SSH keys, DB passwords, WordPress admin)
- [ ] Disaster recovery drill (test VPS restore from snapshot)
- [ ] Performance optimization review
- [ ] Capacity planning (disk, memory, CPU trends)
- [ ] Review and update documentation
- [ ] Review Hostinger ToS for any changes

---

## Emergency Contacts

**Hostinger Support**:
- Support Portal: https://www.hostinger.com/cpanel-login (then Helpdesk)
- Priority: Use support tickets for all issues
- Live Chat: Available for urgent issues
- Response Time: Typically 24-48 hours for tickets

**Before Contacting Support**:
- [ ] Have VPS IP address ready
- [ ] Have customer ID ready
- [ ] Clearly describe issue with timestamps
- [ ] Include what you've already tried
- [ ] Attach relevant logs if malware/security issue

**Escalation Path**:
1. Regular support ticket (non-urgent)
2. Live chat (urgent issues affecting uptime)
3. Phone support (critical account issues)

**What to Report Immediately**:
- Suspected account compromise
- Unexplained traffic spikes
- Provider compliance notices
- Malware detection
- DDoS attacks

---

## Related Documentation

- [Security Baseline for Ubuntu](/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md)
- [Malware Response Procedure](/docs/ops/HOSTINGER_MALWARE_RESPONSE.md)
- [WordPress Hardening Guide](/docs/ops/HOSTINGER_WORDPRESS_HARDENING.md)
- [AI Agent Safety Protocol](/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md)
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md)

**Skills**:
- [Hostinger VPS Operations Skill](/skills/hostinger-vps-ops/skill.md)
- [Terminal & SSH Operations Skill](/skills/terminal-ssh-vps/skill.md)

**Cursor Rules**:
- [Hostinger VPS Compliance Rule](/.cursor/rules/110-hostinger-vps-compliance.md)
- [Security & Secrets Rule](/.cursor/rules/100-security-secrets.md)

---

**Last Updated**: 2025-12-31
