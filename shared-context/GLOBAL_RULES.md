# Global Rules for AI Agents

**Applies to:** Claude, Codex, Gemini
**VPS:** Hostinger (72.62.59.160)
**Last Updated:** 2026-01-20

---

## Session Start Protocol

Every session, perform these steps:

1. **Read shared context:**
   ```
   /root/policies-repo/shared-context/GLOBAL_RULES.md (this file)
   /root/policies-repo/shared-context/VPS_STRUCTURE.md
   /root/policies-repo/shared-context/progress/WEEKLY_PROGRESS.md
   /root/policies-repo/shared-context/progress/ERROR_LOG.md
   ```

2. **Check pending work:**
   ```
   /root/AI_JOBS.md
   /root/manual_jobs.md
   ```

3. **Verify container health:**
   ```bash
   docker ps --format "table {{.Names}}\t{{.Status}}"
   ```

4. **Check for active errors:** Review ERROR_LOG.md for unresolved issues

5. **Identify scope:** Determine which container(s) your task affects

For detailed workflow instructions, see **WORKFLOW_GUIDE.md**.

---

## Update Protocol

### During Work
- Update `/root/AI_JOBS.md` when starting or completing tasks
- Log significant findings in `progress/WEEKLY_PROGRESS.md`
- **Log errors IMMEDIATELY** in `progress/ERROR_LOG.md` when encountered
- Document issues encountered

### Every 10 Minutes (Automated)
- Cron job updates `WEEKLY_PROGRESS.md` timestamp
- Creates checkpoint in `/root/ai-progress/checkpoints/`

### At Session End
- Mark completed tasks in AI_JOBS.md
- Note any handoff items in WEEKLY_PROGRESS.md
- Update ERROR_LOG.md with resolution status for any errors worked on

### Error Logging (Required)
When you encounter an error:
1. Add to Active Errors table in ERROR_LOG.md
2. Create detailed entry with context, cause, and solution attempts
3. Update status when resolved
4. Move to Resolved Archive when fully fixed

---

## Execution Policy

### Safe Operations (Execute Immediately)

**Read Operations:**
```bash
ls, cat, head, tail, less, pwd, whoami
df -h, free -m, ps aux, top, htop
git status, git log, git diff
docker ps, docker images, docker logs, docker inspect
systemctl status <service>
npm list, npm outdated, npm run build
curl -I, wget --spider
```

**Safe Write Operations:**
```bash
mkdir, touch
cp <file> <backup>
git add, git commit, git push (to feature branches only)
npm install (local packages)
npm run build, npm test
```

### Requires Confirmation

**Destructive Operations:**
- `rm -rf`, `rm -r` (recursive delete)
- `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`
- `docker system prune`, `docker volume prune`
- `git push --force`, `git reset --hard`
- `find ... -delete`

**System Modifications:**
- `sudo` commands modifying system config
- `chmod`, `chown` on system files
- `systemctl stop/restart <production-service>`
- `reboot`, `shutdown`, `ufw disable`
- Cron modifications

**Sensitive Data:**
- Accessing/displaying credentials
- Modifying `.env` files
- Changing passwords

---

## Container-Aware Operations

Before modifying any service:

1. **Identify containers:** Which containers are involved?
2. **Check dependencies:** Will this break other services?
3. **Verify backups:** Is there a recent backup? (Daily at 2 AM)
4. **Plan rollback:** How to undo if it fails?
5. **Log intent:** Update AI_JOBS.md with planned action

### Container Quick Reference

| Service | Container(s) | Port |
|---------|-------------|------|
| Flow Control | flow-control-frontend, flow-control-db | 8080, 5432 |
| Flow Auth | flow-auth | 8081 |
| n8n | n8n | 5678 |
| CRM Lite | crmlite-web | 8090 |
| Uptime Kuma | uptime-kuma | 3002 |
| Vtiger | vtiger-app, vtiger-mysql | 8083 |
| Vtiger Secure | vtiger-secure-app, vtiger-secure-db | 8084 |

---

## Hostinger VPS Compliance

### Prohibited (ToS Violations)
- Port scanning external IPs (nmap, masscan)
- Brute force tools (hydra, john, hashcat)
- Malware distribution
- Spam/mass emailing
- Open proxies
- Offensive security tools

### Allowed (Defensive)
- fail2ban, ClamAV
- Firewall configuration (ufw)
- SSH hardening
- Log monitoring
- Malware scans on THIS server

---

## Git Workflow

### Commit Messages (Conventional Commits)
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code change without behavior change
- `docs:` documentation only
- `chore:` maintenance tasks

### Before Push
1. `git status` - verify what's included
2. `git diff --cached` - review changes
3. Verify no secrets in staged files

### Never
- `git push --force` to main/master without explicit approval
- Commit `.env` files or credentials

---

## Emergency Procedures

If something goes wrong:

1. **STOP** current operation immediately
2. **Document** the current state
3. **Do NOT** attempt to fix without assessment
4. **Report** the issue in AI_JOBS.md
5. **Wait** for human review if production is affected

---

## Quick Diagnostics

```bash
# System health
df -h && free -m

# All containers
docker ps -a

# Container logs
docker logs <container-name> --tail 50

# Service status
systemctl status caddy nginx

# Recent auth attempts
sudo tail -20 /var/log/auth.log

# Firewall status
sudo ufw status
```
