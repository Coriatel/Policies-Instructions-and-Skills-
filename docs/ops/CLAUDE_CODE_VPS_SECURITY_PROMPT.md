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
You are running on a Hostinger VPS server. Your task is to review and implement the security configuration based on the organization's security policies.

## Reference Documents

Review these security policies from the Policies-Instructions-and-Skills repository:
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_PROTOCOL.md
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md
- https://github.com/Coriatel/Policies-Instructions-and-Skills-/blob/claude/bootstrap-repo-setup-pnxsB/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md

## Tasks

1. **Audit Current Configuration**
   - Check UFW status and rules
   - Check Fail2Ban status and jails
   - Review SSH configuration
   - Check for automatic updates
   - Verify PostgreSQL is bound to localhost

2. **Report Findings**
   - List what is correctly configured
   - List what needs to be fixed
   - Identify any security gaps

3. **Implement Fixes** (with confirmation for each)
   - Configure missing firewall rules
   - Set up Fail2Ban if not configured
   - Enable automatic security updates
   - Create security audit script

## Required Ports (verify these are open)

| Port | Service | Status |
|------|---------|--------|
| 22 | SSH | Required |
| 80 | HTTP | Required |
| 443 | HTTPS | Required |
| 4000 | API Server | Required for Flow-Control |

## Constraints

- Always ask for confirmation before making changes
- Do not modify SSH configuration that could lock out access
- Create backups before modifying config files
- Document all changes made
- Follow the AI Agent Safety Protocol

## Output Format

Provide:
1. Current security status summary
2. Recommended actions with risk assessment
3. Step-by-step implementation (awaiting confirmation for each)
4. Final verification checklist
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
