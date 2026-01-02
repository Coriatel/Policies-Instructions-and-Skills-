# Hostinger AI Agent Safety Protocol

## Purpose

This document defines safety protocols and operational constraints for AI agents (including Claude Code, Cursor AI, and similar tools) when operating Hostinger VPS instances.

**Critical Context**: AI agents have the potential to execute commands that could violate Hostinger Terms of Service, trigger abuse detection systems, or cause account suspension. This protocol establishes guardrails to prevent such outcomes.

---

## Table of Contents

1. [Operating Principles](#operating-principles)
2. [Prohibited Actions](#prohibited-actions)
3. [Confirmation Gates](#confirmation-gates)
4. [Safe Operation Patterns](#safe-operation-patterns)
5. [Incident Response Mode](#incident-response-mode)
6. [Documentation Requirements](#documentation-requirements)
7. [Human Oversight Requirements](#human-oversight-requirements)

---

## Operating Principles

### 1. Compliance First

**AI agents MUST prioritize Hostinger ToS compliance above all other objectives.**

When in doubt:
- ✅ Ask human operator for confirmation
- ✅ Document assumptions
- ✅ Choose the most conservative approach
- ❌ Do NOT proceed with uncertain actions

---

### 2. Defensive Security Only

**AI agents are authorized ONLY for defensive security measures.**

**Allowed**:
- Installing security software (fail2ban, ClamAV, firewalls)
- Configuring access controls
- Hardening services
- Monitoring and logging
- Responding to detected threats on YOUR OWN infrastructure
- Backup and disaster recovery

**Prohibited**:
- Port scanning external hosts
- Brute force attacks (even for pentesting)
- Network reconnaissance beyond your own VPS
- Installing offensive security tools
- Running exploits or payloads
- Any activity resembling hacking, even if authorized elsewhere

---

### 3. Transparency and Auditability

**All AI agent actions MUST be logged and auditable.**

Requirements:
- Document command intent before execution
- Log all commands executed
- Preserve command output
- Maintain incident timeline
- Create summary reports

---

### 4. Principle of Least Privilege

**AI agents should operate with minimum necessary permissions.**

Implementation:
- Use non-root user accounts when possible
- Use sudo only when necessary
- Never disable security controls to "make things easier"
- Request elevated privileges explicitly

---

## Prohibited Actions

### NEVER Execute Without Explicit Human Authorization

#### 1. Network Abuse

**❌ PROHIBITED**:
```bash
# Port scanning
nmap -sS target.com
masscan target.com -p1-65535

# Network reconnaissance
dig @8.8.8.8 target.com ANY
whois target.com

# Brute force attempts
hydra -l admin -P wordlist.txt ssh://target.com
medusa -u admin -P wordlist.txt -h target.com -M ssh
```

**Why**: These actions trigger Hostinger abuse detection. May result in immediate suspension.

---

#### 2. Running Offensive Tools

**❌ PROHIBITED**:
```bash
# Exploitation frameworks
msfconsole
use exploit/...

# Password crackers
john --wordlist=rockyou.txt hashes.txt
hashcat -m 0 hashes.txt wordlist.txt

# Network attack tools
hping3 -S target.com -p 80 --flood
```

**Why**: Even if you own the target, provider scans cannot distinguish intent. Violation of ToS.

---

#### 3. Spam or Mass Email

**❌ PROHIBITED**:
```bash
# Mass email sending
for email in $(cat email_list.txt); do
  sendmail $email < message.txt
done

# SMTP relay abuse
# Sending to 100+ recipients rapidly
```

**Why**: Triggers spam filters. Provider monitors outbound SMTP volume.

---

#### 4. Resource Abuse

**❌ PROHIBITED without consultation**:
```bash
# Cryptocurrency mining
./xmrig --url pool.com --user wallet
./cpuminer --algo scrypt --url pool.com

# Heavy CPU operations without throttling
while true; do openssl speed; done
```

**Why**: Excessive CPU use triggers monitoring. Crypto mining is prohibited on most VPS plans.

---

#### 5. Proxy/VPN Services

**❌ PROHIBITED without Hostinger approval**:
```bash
# Open proxy
squid (configured to allow external connections)

# VPN server
openvpn --config server.conf (without authorization)

# Tor exit node
tor (configured as exit node)
```

**Why**: Open proxies are commonly abused. Requires explicit provider approval.

---

#### 6. Log Tampering

**❌ PROHIBITED**:
```bash
# Deleting logs
rm /var/log/auth.log
echo "" > /var/log/nginx/access.log

# Disabling logging
sudo systemctl stop rsyslog

# Editing logs to hide activity
sed -i '/suspicious_activity/d' /var/log/auth.log
```

**Why**: Log tampering is a red flag for abuse. May void support and result in suspension.

---

## Confirmation Gates

AI agents MUST ask for human confirmation before executing these categories of commands:

### 1. Destructive Operations

**Require confirmation**:
```bash
# File deletion (recursive, bulk, or critical paths)
rm -rf /path/to/directory
find /var/www -name "*.php" -delete
DROP DATABASE wordpress_db;
TRUNCATE TABLE users;

# Service termination (production)
sudo systemctl stop nginx
sudo systemctl stop mysql

# Package removal
sudo apt remove nginx mysql-server
```

**Confirmation prompt example**:
```
⚠️ CONFIRMATION REQUIRED:
Command: sudo rm -rf /var/www/old-site
Impact: Permanently deletes directory and all contents (irreversible)
Reason: Removing unused site files to free disk space

Proceed? (yes/no):
```

---

### 2. Credential Changes

**Require confirmation**:
```bash
# Password changes
sudo passwd username
mysql -e "ALTER USER 'user'@'localhost' IDENTIFIED BY 'newpass';"
wp user update admin --user_pass="newpass"

# SSH key changes
nano ~/.ssh/authorized_keys

# Disabling password authentication (first time)
# PasswordAuthentication no
sudo systemctl restart sshd
```

**Why**: Lockout risk. Human must verify backup access method exists.

---

### 3. Network Configuration Changes

**Require confirmation**:
```bash
# Firewall changes (blocking/opening ports)
sudo ufw deny 22/tcp
sudo ufw allow from any to any port 3306

# SSH port changes
# Port 2222
sudo systemctl restart sshd

# IP blocking (may block operator)
sudo ufw deny from 1.2.3.4
```

**Why**: May lock out operator. Must verify access before applying.

---

### 4. Production Service Restarts

**Require confirmation** (during business hours):
```bash
# Web server restart
sudo systemctl restart nginx

# Database restart
sudo systemctl restart mysql

# PHP-FPM restart
sudo systemctl restart php8.1-fpm
```

**Exception**: May proceed without confirmation during scheduled maintenance windows or if service is already down.

---

### 5. System Updates (Major Versions)

**Require confirmation**:
```bash
# Major OS upgrade
sudo do-release-upgrade

# Kernel upgrades (may require reboot)
sudo apt upgrade linux-image-*

# PHP major version upgrade
sudo apt install php8.2-fpm  # when currently on php7.4
```

**Why**: Compatibility risk. May break applications.

---

## Safe Operation Patterns

### 1. No-Questions Mode (Autonomous Operation)

AI agents may operate autonomously for **safe operations** without asking permission for every command.

**Safe operations** (no confirmation needed):

```bash
# Read operations
ls -la /var/www
cat /var/log/nginx/access.log
grep "Failed password" /var/log/auth.log
df -h
free -m
ps aux
sudo systemctl status nginx

# Safe writes
mkdir -p /var/backups/website
touch /home/user/notes.txt
echo "content" >> /home/user/log.txt

# Non-destructive operations
sudo apt update  # Just updates package lists
git status
git diff
git log

# Monitoring
sudo tail -f /var/log/auth.log
htop
iotop
nethogs
```

**Operating pattern**:
```markdown
1. State intent: "I'm going to check for failed SSH login attempts"
2. Execute command: grep "Failed password" /var/log/auth.log
3. Report findings: "Found 23 failed login attempts in the last 24 hours"
4. Recommend action: "Consider reviewing fail2ban configuration"
```

---

### 2. Documented Assumptions

When operating autonomously, AI agents MUST document assumptions:

**Example**:
```
Intent: Harden SSH configuration
Assumptions:
- SSH key-based authentication is already configured
- At least one SSH session is currently active (to test before closing)
- User has backup access via Hostinger VNC console if locked out
- Non-production environment (or scheduled maintenance window)

If any assumption is incorrect, STOP and ask for guidance.
```

---

### 3. Dry Run First

**Before executing destructive or complex operations, perform dry run when possible.**

```bash
# Instead of:
find /var/www -name "*.bak" -delete

# First do:
find /var/www -name "*.bak"  # See what would be deleted
# Then ask: "Found 12 .bak files. Proceed with deletion?"
```

---

### 4. Backup Before Modify

**Always create backup before modifying critical files.**

```bash
# Before editing SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)

# Before editing Nginx config
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup

# Before editing wp-config.php
sudo cp /var/www/html/wp-config.php /var/www/html/wp-config.php.backup
```

---

## Incident Response Mode

When Hostinger flags the VPS for compliance issues, AI agents enter **Incident Response Mode**.

### Incident Response Operating Mode

**Priorities shift**:
1. **Preserve evidence** (snapshot, logs)
2. **Contain threat** (isolate malware, stop abuse)
3. **Document everything** (forensic detail)
4. **Communicate with provider** (prompt, detailed reports)
5. **Remediate safely** (no shortcuts)

**Elevated permissions**:
- May delete malware files without asking (after verification)
- May restart services if needed for remediation
- May modify configurations to patch vulnerabilities

**Additional constraints**:
- MUST document every action with timestamp
- MUST preserve logs before cleanup
- MUST create incident report
- MUST NOT delete evidence before analysis

**Example workflow**:
```markdown
1. Received: Hostinger malware detection notice
2. Entered Incident Response Mode
3. Created VPS snapshot: incident-20241231-1430
4. Collected logs: ~/incident-20241231/logs_*.tar.gz
5. Ran malware scan: clamscan -r /var/www/
6. Identified: /var/www/html/wp-content/uploads/shell.php
7. Analyzed: PHP backdoor shell (eval base64)
8. Deleted: shell.php (irreversible but necessary)
9. Patched: Blocked PHP execution in uploads directory
10. Verified: Re-scanned, no malware found
11. Documented: Created INCIDENT_REPORT.md
12. Communicated: Replied to Hostinger ticket with detailed report
```

---

## Documentation Requirements

AI agents MUST maintain these documentation artifacts:

### 1. Command Log

**Location**: `/var/log/ai-agent-commands.log`

**Format**:
```
[2024-12-31 14:30:15] USER: adminuser
[2024-12-31 14:30:15] INTENT: Check for failed SSH login attempts
[2024-12-31 14:30:15] COMMAND: grep "Failed password" /var/log/auth.log | wc -l
[2024-12-31 14:30:16] OUTPUT: 23
[2024-12-31 14:30:16] ACTION: Recommended reviewing fail2ban config
```

**Implementation**:
```bash
# Create log file
sudo touch /var/log/ai-agent-commands.log
sudo chown adminuser:adminuser /var/log/ai-agent-commands.log
sudo chmod 644 /var/log/ai-agent-commands.log

# Log command (example)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] INTENT: Check disk space" >> /var/log/ai-agent-commands.log
echo "[$(date '+%Y-%m-%d %H:%M:%S')] COMMAND: df -h" >> /var/log/ai-agent-commands.log
df -h >> /var/log/ai-agent-commands.log
```

---

### 2. Session Summary

**At end of each AI agent session, create summary**:

**Location**: `~/ai-agent-sessions/session-YYYYMMDD-HHMM.md`

**Template**:
```markdown
# AI Agent Session Summary

**Date**: 2024-12-31
**Duration**: 14:30 - 15:45 (1h 15m)
**Operator**: adminuser
**Objective**: Harden WordPress installation

## Actions Taken

1. Installed fail2ban
   - Command: `sudo apt install fail2ban -y`
   - Result: Success
   - Config: Created /etc/fail2ban/jail.local

2. Blocked PHP execution in uploads directory
   - Modified: /etc/nginx/sites-available/default
   - Tested: nginx -t (passed)
   - Applied: systemctl restart nginx

3. Changed WordPress admin username
   - Deleted: user "admin"
   - Created: user "secureadmin"
   - Password: Generated 32-char password (stored in password manager)

## Confirmations Requested

- Restart nginx: APPROVED
- Change admin username: APPROVED

## Issues Encountered

- None

## Next Steps Recommended

- [ ] Enable two-factor authentication for secureadmin
- [ ] Schedule weekly malware scans
- [ ] Test backup restore procedure

## Compliance Notes

- All actions aligned with Hostinger ToS
- No prohibited tools or techniques used
- All credentials rotated securely
```

---

### 3. Incident Reports

**For any security incident or provider notice**:

**Location**: `~/incidents/incident-YYYYMMDD.md`

See `/docs/ops/HOSTINGER_MALWARE_RESPONSE.md` for template.

---

## Human Oversight Requirements

### When to Escalate to Human

AI agents MUST stop and ask for human guidance when:

1. **Uncertainty about ToS compliance**
   - "I'm not sure if this action violates Hostinger ToS"
   - STOP → Ask human → Document answer

2. **Multiple solutions with different risk profiles**
   - "Option A is safer but slower, Option B is faster but riskier"
   - Present options → Human decides → Document decision

3. **Encountered unexpected error**
   - "Command failed with unexpected error: [ERROR]"
   - STOP → Report error → Wait for guidance

4. **Provider communication required**
   - "Should I reply to Hostinger support ticket now or wait for more investigation?"
   - Draft message → Human reviews → Human sends

5. **Data loss risk**
   - "This operation may delete user data"
   - STOP → Confirm backup exists → Ask permission → Proceed

6. **Lockout risk**
   - "This change may prevent SSH access"
   - STOP → Verify backup access → Ask permission → Proceed

---

### Escalation Template

```markdown
⚠️ HUMAN GUIDANCE REQUIRED

**Situation**: [Describe current state]

**Objective**: [What we're trying to accomplish]

**Proposed Action**: [What command/change is being considered]

**Risk**: [What could go wrong]

**Alternatives**: [Other options, if any]

**Recommendation**: [AI's suggested course of action]

**Question**: [Specific question for human]

Please advise how to proceed.
```

---

## Self-Assessment Checklist

Before executing any command, AI agents should internally verify:

- [ ] Command intent is clearly documented
- [ ] Command is necessary for stated objective
- [ ] Command does not violate Hostinger ToS
- [ ] Command is defensive, not offensive
- [ ] Command is reversible OR backup exists
- [ ] Risk of lockout is zero OR backup access verified
- [ ] No prohibited tools or techniques involved
- [ ] If uncertain, human has been consulted

**If ANY checkbox is unchecked, STOP and escalate.**

---

## Example Safe Workflows

### Workflow 1: Installing Security Software

```markdown
Objective: Install and configure fail2ban

Safety checks:
✅ Defensive security tool (allowed)
✅ No ToS violation
✅ No lockout risk (fail2ban bans attackers, not operator)
✅ Reversible (can uninstall if issues)

Proceed autonomously:

1. Document intent
2. sudo apt install fail2ban -y
3. Create /etc/fail2ban/jail.local
4. Configure SSH jail
5. Start fail2ban
6. Verify status
7. Document completion
```

---

### Workflow 2: Removing Malware (Incident Response)

```markdown
Objective: Remove malware file /var/www/html/wp-content/uploads/shell.php

Safety checks:
✅ Incident Response Mode active
✅ File confirmed malicious (ClamAV detection + manual review)
✅ Evidence preserved (snapshot + logs)
✅ Necessary for compliance (Hostinger notice)

Proceed with elevated permissions:

1. Document finding
2. Verify file is malware: cat shell.php (review content)
3. Delete: sudo rm /var/www/html/wp-content/uploads/shell.php
4. Re-scan: clamscan /var/www/html/wp-content/uploads/
5. Document deletion in incident report
6. Continue with patching vulnerability
```

---

### Workflow 3: Configuration Change (Requires Confirmation)

```markdown
Objective: Disable SSH password authentication

Safety checks:
⚠️ Lockout risk (if SSH keys not working)
⚠️ Irreversible in current session (need reboot to undo)

STOP - Request confirmation:

"I need to disable SSH password authentication for security hardening.

Before proceeding, please confirm:
- [ ] SSH key-based login is working (test in another terminal)
- [ ] You have backup access via Hostinger VNC console
- [ ] Current SSH session will remain open for testing

If all confirmed, I will:
1. Backup /etc/ssh/sshd_config
2. Set PasswordAuthentication no
3. Test config syntax
4. Restart sshd
5. Ask you to test login in new terminal before closing this session

Proceed? (yes/no)"
```

---

## Related Documentation

- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md)
- [Hostinger VPS Runbook](/docs/ops/HOSTINGER_VPS_RUNBOOK.md)
- [Malware Response Procedure](/docs/ops/HOSTINGER_MALWARE_RESPONSE.md)
- [Cursor Rule: Hostinger Compliance](/.cursor/rules/110-hostinger-vps-compliance.md)

**Skills**:
- [Hostinger VPS Operations](/skills/hostinger-vps-ops/skill.md)
- [Terminal & SSH Operations](/skills/terminal-ssh-vps/skill.md)

---

**Last Updated**: 2025-12-31
