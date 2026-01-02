#!/bin/bash
# VPS Security Audit Script (Read-Only)
# Purpose: Audit VPS security posture without making any changes
# Designed for: Hostinger VPS (Ubuntu 20.04+), compatible with other providers
# Safety: This script only reads system state and generates a report

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Output file
REPORT_FILE="/tmp/vps-security-audit-$(date +%Y%m%d_%H%M%S).txt"

# Helper functions
log_section() {
  echo ""  | tee -a "$REPORT_FILE"
  echo "========================================" | tee -a "$REPORT_FILE"
  echo "$1" | tee -a "$REPORT_FILE"
  echo "========================================" | tee -a "$REPORT_FILE"
}

log_pass() {
  echo -e "${GREEN}✓ PASS:${NC} $1" | tee -a "$REPORT_FILE"
}

log_fail() {
  echo -e "${RED}✗ FAIL:${NC} $1" | tee -a "$REPORT_FILE"
}

log_warn() {
  echo -e "${YELLOW}⚠ WARN:${NC} $1" | tee -a "$REPORT_FILE"
}

log_info() {
  echo -e "${BLUE}ℹ INFO:${NC} $1" | tee -a "$REPORT_FILE"
}

# Start audit
echo "=== VPS Security Audit ===" | tee "$REPORT_FILE"
echo "Date: $(date)" | tee -a "$REPORT_FILE"
echo "Hostname: $(hostname)" | tee -a "$REPORT_FILE"
echo "OS: $(lsb_release -d | cut -f2)" | tee -a "$REPORT_FILE"
echo "Kernel: $(uname -r)" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# 1. SSH Configuration
log_section "1. SSH Configuration Security"

if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null; then
  log_pass "SSH password authentication is disabled"
else
  log_fail "SSH password authentication is ENABLED (should be disabled)"
fi

if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
  log_pass "SSH root login is disabled"
else
  log_fail "SSH root login is ENABLED (should be disabled)"
fi

if grep -q "^PubkeyAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
  log_pass "SSH public key authentication is enabled"
else
  log_warn "SSH public key authentication may not be enabled"
fi

SSH_PORT=$(grep "^Port " /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
if [ -n "$SSH_PORT" ] && [ "$SSH_PORT" != "22" ]; then
  log_info "SSH port changed to $SSH_PORT (non-standard port)"
else
  log_info "SSH port is default (22)"
fi

# 2. Firewall Status
log_section "2. Firewall (UFW) Status"

if command -v ufw &> /dev/null; then
  UFW_STATUS=$(sudo ufw status | head -1)
  if echo "$UFW_STATUS" | grep -q "active"; then
    log_pass "UFW firewall is active"

    # Check if SSH is allowed
    if sudo ufw status | grep -q "22.*ALLOW" || sudo ufw status | grep -q "${SSH_PORT}.*ALLOW" 2>/dev/null; then
      log_pass "SSH port is allowed in firewall"
    else
      log_warn "SSH port may not be explicitly allowed in firewall"
    fi

    # Check if HTTP/HTTPS are allowed (if web server present)
    if command -v nginx &> /dev/null || command -v apache2 &> /dev/null; then
      if sudo ufw status | grep -q "80.*ALLOW"; then
        log_pass "HTTP (80) is allowed"
      else
        log_warn "HTTP (80) is not allowed (may be intentional)"
      fi

      if sudo ufw status | grep -q "443.*ALLOW"; then
        log_pass "HTTPS (443) is allowed"
      else
        log_warn "HTTPS (443) is not allowed (may be intentional)"
      fi
    fi
  else
    log_fail "UFW firewall is INACTIVE"
  fi
else
  log_fail "UFW is not installed"
fi

# 3. Fail2Ban Status
log_section "3. Fail2Ban (Intrusion Prevention)"

if command -v fail2ban-client &> /dev/null; then
  log_pass "Fail2Ban is installed"

  if sudo systemctl is-active --quiet fail2ban; then
    log_pass "Fail2Ban service is running"

    # Check SSH jail
    if sudo fail2ban-client status sshd &> /dev/null; then
      log_pass "SSH jail is active"

      BANNED_COUNT=$(sudo fail2ban-client status sshd | grep "Currently banned" | awk '{print $NF}')
      TOTAL_BANNED=$(sudo fail2ban-client status sshd | grep "Total banned" | awk '{print $NF}')
      log_info "Currently banned IPs: $BANNED_COUNT, Total banned: $TOTAL_BANNED"
    else
      log_warn "SSH jail is not active"
    fi
  else
    log_fail "Fail2Ban service is NOT running"
  fi
else
  log_fail "Fail2Ban is not installed"
fi

# 4. System Updates
log_section "4. System Updates & Patches"

if command -v apt &> /dev/null; then
  # This only checks cache, doesn't update lists
  UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -c upgradable || true)

  if [ "$UPGRADABLE" -eq 0 ]; then
    log_pass "System is up to date (no packages pending upgrade)"
  else
    log_warn "$UPGRADABLE packages have updates available"
  fi

  # Check if unattended-upgrades is installed
  if dpkg -l | grep -q unattended-upgrades; then
    log_pass "Unattended-upgrades package is installed"
  else
    log_warn "Unattended-upgrades is not installed (automatic security updates recommended)"
  fi
fi

# Check kernel version vs running kernel (reboot needed?)
CURRENT_KERNEL=$(uname -r)
LATEST_KERNEL=$(dpkg -l | grep linux-image | grep -v generic | tail -1 | awk '{print $2}' | sed 's/linux-image-//')

if [ "$CURRENT_KERNEL" != "$LATEST_KERNEL" ] && [ -n "$LATEST_KERNEL" ]; then
  log_warn "Kernel update available. Reboot may be needed. Current: $CURRENT_KERNEL, Latest: $LATEST_KERNEL"
else
  log_pass "Running latest kernel"
fi

# 5. File System Security
log_section "5. File System Security"

# Check for world-writable files in web root (if exists)
if [ -d "/var/www" ]; then
  WORLD_WRITABLE_FILES=$(sudo find /var/www -type f -perm -002 2>/dev/null | wc -l)

  if [ "$WORLD_WRITABLE_FILES" -eq 0 ]; then
    log_pass "No world-writable files in /var/www"
  else
    log_fail "$WORLD_WRITABLE_FILES world-writable files found in /var/www (security risk)"
  fi

  # Check for PHP files in uploads (WordPress)
  if [ -d "/var/www/html/wp-content/uploads" ]; then
    PHP_IN_UPLOADS=$(sudo find /var/www/html/wp-content/uploads -name "*.php" 2>/dev/null | wc -l)

    if [ "$PHP_IN_UPLOADS" -eq 0 ]; then
      log_pass "No PHP files in WordPress uploads directory"
    else
      log_fail "$PHP_IN_UPLOADS PHP files found in uploads (malware risk)"
    fi
  fi

  # Check wp-config.php permissions (if WordPress)
  if [ -f "/var/www/html/wp-config.php" ]; then
    WP_CONFIG_PERMS=$(stat -c %a /var/www/html/wp-config.php)

    if [ "$WP_CONFIG_PERMS" = "440" ] || [ "$WP_CONFIG_PERMS" = "400" ]; then
      log_pass "wp-config.php has secure permissions ($WP_CONFIG_PERMS)"
    else
      log_warn "wp-config.php permissions are $WP_CONFIG_PERMS (recommend 440 or 400)"
    fi
  fi
fi

# Check for .git directories in web root
if [ -d "/var/www" ]; then
  GIT_DIRS=$(sudo find /var/www -type d -name ".git" 2>/dev/null | wc -l)

  if [ "$GIT_DIRS" -eq 0 ]; then
    log_pass "No .git directories in web root"
  else
    log_fail "$GIT_DIRS .git directories found in web root (information disclosure risk)"
  fi
fi

# 6. User Accounts
log_section "6. User Accounts & Authentication"

# Check for accounts with bash shell (potential login accounts)
BASH_USERS=$(grep "/bin/bash" /etc/passwd | grep -v "^root:" | wc -l)
log_info "$BASH_USERS non-root user(s) with bash shell"

# Check for root account lock status
if sudo passwd -S root 2>/dev/null | grep -q " L "; then
  log_pass "Root account password is locked"
else
  log_warn "Root account password is NOT locked"
fi

# Check for empty password accounts
EMPTY_PASS=$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow 2>/dev/null | wc -l)

if [ "$EMPTY_PASS" -eq 0 ]; then
  log_pass "No accounts with empty passwords"
else
  log_fail "$EMPTY_PASS account(s) with empty passwords found"
fi

# 7. Network Security
log_section "7. Network Security"

# Check MySQL binding
if command -v mysql &> /dev/null; then
  if sudo netstat -tulpn 2>/dev/null | grep mysql | grep -q "127.0.0.1:3306"; then
    log_pass "MySQL is bound to localhost only (127.0.0.1)"
  elif sudo netstat -tulpn 2>/dev/null | grep mysql | grep -q "0.0.0.0:3306"; then
    log_fail "MySQL is bound to all interfaces (0.0.0.0) - security risk"
  fi
fi

# Check for unexpected listening services
log_info "Listening services:"
sudo netstat -tulpn 2>/dev/null | grep LISTEN | awk '{print $4, $7}' | tee -a "$REPORT_FILE"

# 8. Disk Usage
log_section "8. Disk Usage"

DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -lt 80 ]; then
  log_pass "Disk usage is ${DISK_USAGE}% (healthy)"
elif [ "$DISK_USAGE" -lt 90 ]; then
  log_warn "Disk usage is ${DISK_USAGE}% (consider cleanup)"
else
  log_fail "Disk usage is ${DISK_USAGE}% (critical - cleanup needed)"
fi

# 9. Security Software
log_section "9. Security Software"

# ClamAV
if command -v clamscan &> /dev/null; then
  log_pass "ClamAV antivirus is installed"

  # Check virus DB age
  if [ -f "/var/lib/clamav/daily.cvd" ] || [ -f "/var/lib/clamav/daily.cld" ]; then
    DB_AGE_DAYS=$(find /var/lib/clamav -name "daily.c*" -mtime +7 | wc -l)

    if [ "$DB_AGE_DAYS" -eq 0 ]; then
      log_pass "ClamAV virus database is up to date"
    else
      log_warn "ClamAV virus database is outdated (run freshclam)"
    fi
  fi
else
  log_warn "ClamAV antivirus is not installed (recommended for malware scanning)"
fi

# AppArmor
if command -v aa-status &> /dev/null; then
  if sudo aa-status --enabled 2>/dev/null; then
    log_pass "AppArmor is enabled"
  else
    log_warn "AppArmor is not enabled"
  fi
else
  log_info "AppArmor is not installed"
fi

# 10. Logs & Monitoring
log_section "10. Logs & Monitoring"

# Check for recent failed SSH attempts
FAILED_SSH=$(sudo grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %d)" | wc -l)

if [ "$FAILED_SSH" -eq 0 ]; then
  log_pass "No failed SSH attempts today"
elif [ "$FAILED_SSH" -lt 10 ]; then
  log_info "$FAILED_SSH failed SSH attempts today (low volume)"
else
  log_warn "$FAILED_SSH failed SSH attempts today (investigate if unusual)"
fi

# Check auth log file size (should exist and rotate)
if [ -f "/var/log/auth.log" ]; then
  AUTH_LOG_SIZE=$(stat -c%s "/var/log/auth.log")

  if [ "$AUTH_LOG_SIZE" -gt 10485760 ]; then  # 10MB
    log_warn "auth.log is large ($(numfmt --to=iec-i --suffix=B $AUTH_LOG_SIZE)) - check log rotation"
  else
    log_pass "auth.log size is reasonable"
  fi
else
  log_fail "/var/log/auth.log does not exist"
fi

# 11. WordPress Specific (if detected)
if [ -f "/var/www/html/wp-config.php" ]; then
  log_section "11. WordPress Security"

  # Check WordPress version (requires wp-cli)
  if command -v wp &> /dev/null; then
    WP_VERSION=$(sudo -u www-data wp core version --path=/var/www/html 2>/dev/null || echo "unknown")
    log_info "WordPress version: $WP_VERSION"

    # Check for plugin updates
    PLUGIN_UPDATES=$(sudo -u www-data wp plugin list --update=available --path=/var/www/html --format=count 2>/dev/null || echo "0")

    if [ "$PLUGIN_UPDATES" -eq 0 ]; then
      log_pass "All WordPress plugins are up to date"
    else
      log_warn "$PLUGIN_UPDATES WordPress plugin(s) have updates available"
    fi

    # Check for admin username
    if sudo -u www-data wp user list --role=administrator --path=/var/www/html --format=csv 2>/dev/null | grep -q ",admin,"; then
      log_fail "WordPress has default 'admin' username (security risk)"
    else
      log_pass "WordPress does not use default 'admin' username"
    fi
  else
    log_info "WP-CLI not installed (can't check WordPress details)"
  fi

  # Check if file editing is disabled
  if sudo grep -q "define.*DISALLOW_FILE_EDIT.*true" /var/www/html/wp-config.php 2>/dev/null; then
    log_pass "WordPress file editing is disabled (DISALLOW_FILE_EDIT)"
  else
    log_warn "WordPress file editing is not disabled (recommend adding DISALLOW_FILE_EDIT)"
  fi
fi

# 12. Summary
log_section "12. Summary"

# Count results
PASS_COUNT=$(grep -c "✓ PASS" "$REPORT_FILE" || echo "0")
FAIL_COUNT=$(grep -c "✗ FAIL" "$REPORT_FILE" || echo "0")
WARN_COUNT=$(grep -c "⚠ WARN" "$REPORT_FILE" || echo "0")

echo "Passed: $PASS_COUNT" | tee -a "$REPORT_FILE"
echo "Failed: $FAIL_COUNT" | tee -a "$REPORT_FILE"
echo "Warnings: $WARN_COUNT" | tee -a "$REPORT_FILE"

if [ "$FAIL_COUNT" -eq 0 ]; then
  log_pass "No critical security issues detected"
else
  log_fail "$FAIL_COUNT critical security issue(s) detected - review and remediate"
fi

echo "" | tee -a "$REPORT_FILE"
echo "Full report saved to: $REPORT_FILE" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"
echo "=== Audit Complete ===" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Recommended actions
if [ "$FAIL_COUNT" -gt 0 ] || [ "$WARN_COUNT" -gt 0 ]; then
  log_section "Recommended Actions"

  if ! grep -q "✓ PASS: SSH password authentication is disabled" "$REPORT_FILE"; then
    echo "1. Disable SSH password authentication: Set 'PasswordAuthentication no' in /etc/ssh/sshd_config" | tee -a "$REPORT_FILE"
  fi

  if ! grep -q "✓ PASS: UFW firewall is active" "$REPORT_FILE"; then
    echo "2. Enable UFW firewall: sudo ufw enable" | tee -a "$REPORT_FILE"
  fi

  if ! grep -q "✓ PASS: Fail2Ban is installed" "$REPORT_FILE"; then
    echo "3. Install Fail2Ban: sudo apt install fail2ban" | tee -a "$REPORT_FILE"
  fi

  if [ "$DISK_USAGE" -ge 90 ]; then
    echo "4. Free up disk space (currently ${DISK_USAGE}%)" | tee -a "$REPORT_FILE"
  fi

  echo "" | tee -a "$REPORT_FILE"
  echo "For detailed security hardening, see:" | tee -a "$REPORT_FILE"
  echo "- /docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md" | tee -a "$REPORT_FILE"
  echo "- /docs/ops/HOSTINGER_VPS_RUNBOOK.md" | tee -a "$REPORT_FILE"
fi

echo ""
echo "You can review the full report at: $REPORT_FILE"
echo ""

exit 0
