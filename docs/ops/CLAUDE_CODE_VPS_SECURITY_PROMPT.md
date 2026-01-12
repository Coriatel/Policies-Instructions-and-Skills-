# Claude Code CLI - VPS Security Update Prompt

## Purpose

This document contains a ready-to-use prompt for Claude Code CLI running on your Hostinger VPS server. Use this prompt to have Claude Code review and implement security configurations based on the policies in this repository.

---

## Quick Usage

1. SSH into your VPS
2. Navigate to a working directory
3. Run `claude` to start Claude Code CLI
4. Paste the prompt below

---

## Complete Security Setup Prompt

```
You are running on a Hostinger VPS server. Your task is to FIRST audit and report what is already correctly configured, then identify gaps and suggest fixes.

## Reference Documents

Review these security policies from the Policies-Instructions-and-Skills repository:
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_PROTOCOL.md
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md

## Tasks (IN THIS ORDER - Audit First!)

### Phase 1: Audit What's Already Done (DO THIS FIRST)
Run these checks and report current status:

1. **Firewall (UFW)**
   ```bash
   sudo ufw status verbose
   ```

2. **Fail2Ban**
   ```bash
   sudo systemctl status fail2ban
   sudo fail2ban-client status
   sudo fail2ban-client status sshd 2>/dev/null
   ```

3. **SSH Configuration**
   ```bash
   grep -E "^PasswordAuthentication|^PermitRootLogin|^PubkeyAuthentication" /etc/ssh/sshd_config
   ```

4. **Automatic Updates**
   ```bash
   sudo systemctl status unattended-upgrades
   dpkg -l | grep unattended-upgrades
   ```

5. **Database Binding**
   ```bash
   sudo ss -tulpn | grep -E "5432|3306"
   ```

6. **Running Services**
   ```bash
   pm2 status 2>/dev/null || echo "PM2 not installed"
   sudo systemctl list-units --type=service --state=running | head -20
   ```

7. **SSL Certificates**
   ```bash
   sudo certbot certificates 2>/dev/null || echo "Certbot not installed"
   ```

8. **Listening Ports**
   ```bash
   sudo ss -tulpn | grep LISTEN
   ```

### Phase 2: Report Findings (Clear Summary)
Present a clear status table showing what's ALREADY WORKING:

| Component | Status | Details |
|-----------|--------|---------|
| UFW Firewall | ✅/❌ | [list open ports] |
| Fail2Ban | ✅/❌ | [jails active, bans count] |
| SSH Hardening | ✅/❌ | [password auth on/off] |
| Auto Updates | ✅/❌ | [enabled/disabled] |
| Database | ✅/❌ | [localhost only?] |
| SSL/TLS | ✅/❌ | [cert status] |
| PM2 | ✅/❌ | [processes running] |

### Phase 3: Compare Against Requirements
Check against required configuration:

**Required Ports:**
| Port | Service | Required | Currently Open |
|------|---------|----------|----------------|
| 22 | SSH | Yes | ? |
| 80 | HTTP | Yes | ? |
| 443 | HTTPS | Yes | ? |
| 4000 | API Server | Yes | ? |

### Phase 4: Identify Gaps (What's Missing)
List ONLY what needs to be fixed:
- Missing configurations
- Incorrect settings
- Security improvements needed

### Phase 5: Suggest Fixes (ONLY AFTER Phases 1-4)
For each gap:
- Explain what needs to be done
- Show the exact command
- **WAIT for my confirmation before executing**

## Constraints

- DO NOT make any changes until you complete the full audit (Phases 1-4)
- Report what's WORKING CORRECTLY first - acknowledge good configuration
- Always ask for confirmation before making ANY changes
- Do not modify SSH configuration that could lock out access
- Create backups before modifying config files
- Document all changes made

## Output Format

1. **✅ What's Already Configured Correctly** (acknowledge existing good setup)
2. **⚠️ What Needs Attention** (gaps to fix)
3. **📋 Recommended Actions** (with commands, awaiting my approval)
```

---

## Focused Prompts

### Firewall Audit Only

```
Audit the UFW firewall configuration on this VPS:

1. Run: sudo ufw status verbose
2. Compare against required ports:
   - 22/tcp (SSH)
   - 80/tcp (HTTP)
   - 443/tcp (HTTPS)
   - 4000/tcp (API Server)
3. Report any missing or unnecessary rules
4. Suggest fixes but wait for confirmation before applying

Reference: https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_PROTOCOL.md
```

### Fail2Ban Setup

```
Set up or verify Fail2Ban configuration:

1. Check if Fail2Ban is installed: dpkg -l | grep fail2ban
2. If not installed, install it: sudo apt install fail2ban -y
3. Check current jails: sudo fail2ban-client status
4. Configure SSH jail with these settings:
   - maxretry = 3
   - bantime = 86400 (24 hours)
   - findtime = 600 (10 minutes)
5. Verify jail is active: sudo fail2ban-client status sshd

Reference: https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_PROTOCOL.md#fail2ban-setup
```

### Quick Security Audit

```
Run a quick security audit of this VPS:

1. Check firewall: sudo ufw status
2. Check Fail2Ban: sudo fail2ban-client status sshd
3. Check failed SSH attempts: grep "Failed password" /var/log/auth.log | tail -20
4. Check disk space: df -h
5. Check memory: free -h
6. Check running services: systemctl list-units --type=service --state=running
7. Check listening ports: sudo ss -tulpn

Report findings in a summary table format.
```

### SSL Certificate Check

```
Check SSL certificate configuration:

1. List certificates: sudo certbot certificates
2. Test auto-renewal: sudo certbot renew --dry-run
3. Check Nginx SSL configuration: grep -r "ssl" /etc/nginx/sites-enabled/
4. Report certificate expiry dates and any issues

If certificates are missing, guide me through setting up Let's Encrypt.
```

---

## Automated Security Check Script

Create this script on the server to run periodic checks:

```bash
#!/bin/bash
# Save as: /usr/local/bin/vps-security-check.sh

echo "=== VPS Security Check - $(date) ==="
echo ""

echo "[1] Firewall Status:"
sudo ufw status | head -5
echo ""

echo "[2] Fail2Ban Bans (SSH):"
sudo fail2ban-client status sshd 2>/dev/null | grep -E "Currently banned|Total banned" || echo "Fail2Ban not configured"
echo ""

echo "[3] Failed SSH (last 24h):"
grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %d)" | wc -l
echo ""

echo "[4] Disk Space:"
df -h / | tail -1
echo ""

echo "[5] Memory:"
free -h | grep Mem
echo ""

echo "[6] Open Ports:"
sudo ss -tulpn | grep LISTEN | awk '{print $5}' | sort -u
echo ""

echo "[7] PM2 Status:"
pm2 status 2>/dev/null || echo "PM2 not running"
echo ""

echo "=== Check Complete ==="
```

---

## Important Notes

1. **Always Run as Non-Root**: Claude Code should operate with sudo when needed, not as root directly

2. **Backup Before Changes**: Always create backups of config files:
   ```bash
   sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)
   ```

3. **Test SSH Access**: Before modifying SSH config, ensure you have:
   - A second terminal with active SSH session
   - VNC console access via Hostinger hPanel

4. **Document Changes**: All changes should be logged to:
   ```bash
   echo "[$(date)] Changed X to Y" >> ~/security-changes.log
   ```

---

## Repository Links

- **Main Repo**: https://github.com/Coriatel/Policies-Instructions-and-Skills-
- **Security Protocol**: [HOSTINGER_SECURITY_PROTOCOL.md](./HOSTINGER_SECURITY_PROTOCOL.md)
- **Security Baseline**: [HOSTINGER_SECURITY_BASELINE_UBUNTU.md](./HOSTINGER_SECURITY_BASELINE_UBUNTU.md)
- **AI Safety**: [HOSTINGER_AI_AGENT_SAFETY.md](./HOSTINGER_AI_AGENT_SAFETY.md)
- **VPS Runbook**: [HOSTINGER_VPS_RUNBOOK.md](./HOSTINGER_VPS_RUNBOOK.md)

---

**Last Updated**: 2026-01
