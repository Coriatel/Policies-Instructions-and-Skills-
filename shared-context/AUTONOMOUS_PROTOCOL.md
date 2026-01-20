# Autonomous Agent Execution Protocol

**Purpose:** Define safe boundaries for autonomous AI agent operation.
**Applies to:** Claude, Codex, Gemini on this VPS
**Last Updated:** 2026-01-20

---

## Overview

AI agents on this VPS operate autonomously within defined safety boundaries. This document specifies what actions are safe to execute immediately and which require human confirmation.

**Principle:** Autonomous for routine work, cautious for irreversible actions.

---

## Automatic Approval (Execute Immediately)

### Read Operations
```bash
# File system
ls, cat, head, tail, less, pwd, whoami, file, stat
find (without -delete), locate, tree

# System status
df -h, free -m, ps aux, top, htop
uptime, uname -a, hostname, id

# Git (read-only)
git status, git log, git diff, git branch
git show, git blame, git stash list

# Docker (read-only)
docker ps, docker images, docker logs
docker inspect, docker stats, docker network ls

# Service status
systemctl status <any-service>
journalctl (read-only)

# Network diagnostics
curl -I, wget --spider, ping (limited)
ss, netstat, ip addr

# Package info
npm list, npm outdated, npm view
apt list, dpkg -l
```

### Safe Write Operations
```bash
# File creation (new files only)
mkdir, touch
echo "content" > new_file.txt

# File backup
cp file file.backup
cp -r dir dir.backup

# Git operations (non-destructive)
git add
git commit -m "message"
git push origin <feature-branch>  # NOT main/master
git checkout -b <new-branch>
git stash, git stash pop

# Development
npm install (local, no --global)
npm run build
npm run dev
npm test
npm run lint

# Safe container operations
docker logs <container> --tail N
docker exec <container> <read-command>
```

---

## Requires Human Confirmation

### Destructive Operations
| Operation | Risk | Why |
|-----------|------|-----|
| `rm -rf`, `rm -r` | HIGH | Recursive delete can't be undone |
| `DROP DATABASE`, `DROP TABLE` | CRITICAL | Data loss |
| `TRUNCATE` | HIGH | Removes all table data |
| `docker system prune` | MEDIUM | Removes unused resources |
| `docker volume prune` | HIGH | May delete persistent data |
| `git push --force` | HIGH | Rewrites history |
| `git reset --hard` | HIGH | Discards changes |
| `find ... -delete` | HIGH | Bulk file deletion |

### System Modifications
| Operation | Risk | Why |
|-----------|------|-----|
| `sudo` (config changes) | MEDIUM | System-level impact |
| `chmod`, `chown` on system files | MEDIUM | Permission changes |
| `systemctl restart` (production) | MEDIUM | Service interruption |
| `reboot`, `shutdown` | HIGH | Full service outage |
| `ufw disable` | HIGH | Security exposure |
| Cron modifications | MEDIUM | Affects automation |

### Sensitive Data
| Operation | Risk | Why |
|-----------|------|-----|
| Reading `.env` files | MEDIUM | May expose secrets |
| Displaying credentials | HIGH | Security breach |
| Modifying passwords | HIGH | Access control |
| Accessing `/etc/shadow` | CRITICAL | System security |

### Production Changes
| Operation | Risk | Why |
|-----------|------|-----|
| Database schema changes | MEDIUM | May break application |
| Git push to main/master | MEDIUM | Affects production |
| Service configuration changes | MEDIUM | May cause outages |
| DNS/domain changes | MEDIUM | Affects accessibility |

---

## Pre-Flight Checklist

Before ANY modification, verify:

### 1. Identify Impact
- [ ] Which containers/services are affected?
- [ ] Are there dependent services?
- [ ] Is this a production service?

### 2. Check Backups
- [ ] When was the last backup? (Daily at 2 AM)
- [ ] Is the affected data backed up?
- [ ] Can we restore if needed?

### 3. Plan Rollback
- [ ] How do we undo this change?
- [ ] Do we need to create a backup first?
- [ ] What's the recovery procedure?

### 4. Document Intent
- [ ] Updated AI_JOBS.md with planned action
- [ ] Logged in WEEKLY_PROGRESS.md
- [ ] Noted any risks identified

---

## Container-Specific Rules

### flow-control (Production CRM)
- **Caution:** Has live data
- **DB access:** Read-only queries safe, writes need review
- **Frontend:** Build changes safe, config changes need review
- **Auth:** Any changes require careful testing

### n8n (Automation)
- **Caution:** Workflows may trigger external actions
- **Safe:** Viewing workflows, logs
- **Risky:** Activating/modifying workflows (may send emails, etc.)

### vtiger (CRM with customer data)
- **Caution:** Contains real customer information
- **Safe:** Reading logs, checking status
- **Risky:** Any data modifications

### uptime-kuma (Monitoring)
- **Caution:** Restart may cause false alerts
- **Safe:** Viewing status, adding monitors
- **Risky:** Deleting monitors, changing notification settings

---

## Emergency Stop Procedure

If something goes wrong:

```
1. STOP    - Halt current operation immediately
2. ASSESS  - What happened? What's the current state?
3. CONTAIN - Prevent further damage (don't make it worse)
4. DOCUMENT - Record what happened in AI_JOBS.md
5. REPORT  - Add [EMERGENCY] tag to job entry
6. WAIT    - Do not attempt fixes without human review
```

### Emergency Commands (Safe)
```bash
# Check container status
docker ps -a

# View recent logs
docker logs <container> --tail 100

# Check system resources
df -h && free -m

# View recent errors
journalctl -p err --since "1 hour ago"
```

### DO NOT (During Emergency)
- Restart services without understanding the issue
- Delete files to "clean up"
- Make additional changes hoping to fix it
- Push code to production

---

## Escalation Triggers

Immediately stop and report if you encounter:

1. **Security indicators:**
   - Suspicious processes
   - Unknown network connections
   - Modified system files
   - Failed authentication spikes

2. **Data issues:**
   - Database corruption
   - Missing critical files
   - Unexpected permission changes

3. **Service failures:**
   - Multiple containers down
   - Database connection failures
   - Persistent 5xx errors

4. **Resource exhaustion:**
   - Disk > 90% full
   - Memory > 95% used
   - CPU sustained > 95%

---

## Audit Trail Requirements

Every significant action must be logged:

```markdown
## AI_JOBS.md Entry Format

- [x] **[Date] Task Description**
  - **Agent:** Claude/Codex/Gemini (model version)
  - **Duration:** Approximate time
  - **Action:** What was done
  - **Result:** Outcome
  - **Files Modified:** List of changed files
  - **Issues:** Any problems encountered
```

---

## Summary: Quick Reference

| Action Type | Autonomous? | Confirmation Required? |
|-------------|-------------|----------------------|
| Read anything | Yes | No |
| Create new files | Yes | No |
| npm install/build/test | Yes | No |
| Git commit to feature branch | Yes | No |
| Delete files | NO | YES |
| Modify system config | NO | YES |
| Push to main | NO | YES |
| Restart production | NO | YES |
| Database writes | Case-by-case | Prefer YES |

**When in doubt, ask first.**
