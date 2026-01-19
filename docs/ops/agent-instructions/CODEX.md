# Codex CLI Instructions — Hostinger VPS

## Policies Source
All policies sourced from: `/root/policies-repo/`
GitHub: https://github.com/Coriatel/Policies-Instructions-and-Skills-.git

## 📋 AI Job Tracker
**IMPORTANT:** Check `/root/AI_JOBS.md` at the start of each session for pending work.
When a user asks for a task, add or update that task in `/root/AI_JOBS.md` first (and `/root/manual_jobs.md` if it's a manual task), then proceed.
Update it when you complete tasks or discover new jobs.
Every 5 minutes, update `/root/AI_JOBS.md` and `/root/manual_jobs.md` with progress, what was done, and next steps.

---

## Execution Policy (Terminal Commands)

**Run commands without asking for confirmation** except for:
- Commands that delete data permanently (rm -rf, DROP DATABASE, TRUNCATE)
- Commands that modify critical system files (/etc/passwd, /etc/shadow, /etc/sudoers)
- Commands that could cause service outages in production
- Commands that expose sensitive credentials
- Irreversible operations (force push, database drops, hard resets)
- System modifications (reboot, shutdown, ufw disable)

For all other commands: **Execute immediately without prompting**.

---

## Safe Operations (No Confirmation Needed)

### Read Operations
- ls, cat, head, tail, less, pwd, whoami
- df -h, free -m, ps aux, top, htop
- git status, git log, git diff
- docker ps, docker images, docker logs
- systemctl status <service>
- npm list, npm outdated

### Safe Write Operations
- mkdir, touch, cp <file> <backup>
- git add, git commit, git push (to feature branches)
- npm install (local packages)

---

## Prohibited Without Confirmation

### Destructive Operations
- rm -rf, rm -r, rmdir (recursive/bulk)
- DROP DATABASE, DROP TABLE, TRUNCATE
- docker system prune, docker volume prune
- git push --force, git reset --hard

### System Changes
- sudo commands that modify system config
- chmod, chown on system files
- systemctl stop/restart <production-service>
- reboot, shutdown, ufw disable

---

## Hostinger VPS Compliance

### Prohibited by ToS
- NO malware distribution
- NO spam/mass emailing
- NO port scanning (nmap, masscan on external IPs)
- NO brute force attacks
- NO open proxies
- NO offensive security tools

### Allowed (Defensive Security)
- fail2ban, ClamAV, security plugins
- Firewall configuration on YOUR VPS
- Hardening SSH, web servers
- Monitoring logs

---

## Development Stack (Defaults)

- React + JavaScript (RTL-ready, Hebrew default)
- Node.js + Express backend
- Prisma + PostgreSQL
- Docker/Compose for deployment
- Vitest + Playwright for testing

## Code Standards

- ES6+, Airbnb ESLint, Prettier
- Conventional Commits (feat:, fix:, etc.)
- CSS Logical Properties for RTL

---

## When to Ask vs Proceed

### Ask First
- Destructive operations
- Uncertain business logic
- Accessing secrets
- Modifying production

### Proceed Autonomously
- Reading files
- Checking status
- Creating new files
- Running tests
- Small, clear fixes

---

**Policy Repository**: /root/policies-repo/
**AI Job Tracker**: /root/AI_JOBS.md
**Last Updated**: 2026-01-14
