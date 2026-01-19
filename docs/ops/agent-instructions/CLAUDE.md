# Claude Code Global Instructions — Hostinger VPS

## Policies Source
All policies are sourced from: `/root/policies-repo/`
GitHub: https://github.com/Coriatel/Policies-Instructions-and-Skills-.git

## Skills Index
Claude skill picker: `/root/policies-repo/skills/INDEX-CLAUDE.md`
Keep this index updated whenever new skills are added or modified.

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
```bash
ls, cat, head, tail, less, pwd, whoami
df -h, free -m, ps aux, top, htop
git status, git log, git diff
docker ps, docker images, docker logs
systemctl status <service>
npm list, npm outdated
```

### Safe Write Operations
```bash
mkdir, touch, cp <file> <backup>
git add, git commit, git push (to feature branches)
npm install (local packages)
```

---

## Prohibited Without Confirmation

### Destructive Operations
- `rm -rf`, `rm -r`, `rmdir` (recursive/bulk)
- `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`
- `docker system prune`, `docker volume prune`
- `git push --force`, `git reset --hard`
- `find . -name "*.js" -delete`

### System Changes
- `sudo` commands that modify system config
- `chmod`, `chown` on system files
- `systemctl stop/restart <production-service>`
- `reboot`, `shutdown`, `ufw disable`

---

## Hostinger VPS Compliance (Critical!)

### Prohibited by ToS
- NO malware distribution
- NO spam/mass emailing
- NO port scanning (nmap, masscan on external IPs)
- NO brute force attacks (hydra, john, hashcat)
- NO open proxies
- NO offensive security tools

### Allowed (Defensive Security)
- fail2ban, ClamAV, security plugins
- Firewall configuration on YOUR VPS
- Hardening SSH, web servers
- Monitoring logs
- Running malware scans on YOUR server

### If Provider Flags Server
1. **Acknowledge** - respond within 24 hours
2. **Freeze** - stop all non-essential changes
3. **Preserve** - snapshot + save logs
4. **Investigate** - find the issue
5. **Clean** - remove malware, patch vulnerability
6. **Rotate** - change ALL credentials
7. **Report** - detailed response to provider
8. **Monitor** - watch for 48-72 hours

---

## Development Stack (Defaults)

### Frontend
- React + JavaScript (TypeScript only if specified)
- RTL-ready with Hebrew as default
- react-i18next for translations
- SCSS with BEM naming
- PropTypes for type checking

### Backend
- Node.js + Express
- Joi for validation
- Helmet.js for security headers
- bcrypt for password hashing
- JWT (access + refresh tokens)

### Database
- Prisma with PostgreSQL (primary)
- MongoDB (only for specific needs like logs)

### Testing
- Vitest for unit tests
- Playwright for E2E tests

### Deployment
- Docker/Compose for production
- Caddy or Nginx as reverse proxy
- Hostinger VPS

---

## Code Standards

### Style
- Modern ES6+ (destructuring, arrow functions, async/await)
- Airbnb ESLint config
- Prettier (2-space indent, single quotes, semicolons)

### Naming
- Components: PascalCase (Button.jsx)
- Utils: camelCase (dateUtils.js)
- Constants: UPPER_SNAKE_CASE (API_ROUTES.js)
- Styles: kebab-case (auth-form.scss)

### RTL/Hebrew
- CSS Logical Properties: `margin-inline-start` not `margin-left`
- `dir="rtl"` on HTML
- `dir="ltr"` for URLs, emails, numbers
- Tables: headers right-aligned, actions on left

---

## Git Workflow

### Commit Messages (Conventional Commits)
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code change without behavior change
- `docs:` documentation only
- `test:` adding or updating tests
- `chore:` maintenance tasks

### Before Push
- `git status` - verify what's included
- `git diff --cached` - review changes
- Verify no secrets in staged files

### Never
- `git push --force` to main/master (without explicit approval)
- Commit .env files or credentials

---

## When to Ask vs Proceed

### Ask First
- Before destructive operations
- When uncertain about business logic
- When accessing secrets
- When modifying production

### Proceed Autonomously
- Reading files
- Checking status
- Creating new files (not overwriting)
- Running tests
- Small, clear fixes

---

## Quick Reference Commands

### Development
```bash
docker-compose up -d
npm run dev
npm test
npm run test:e2e
npm run db:migrate
npm run db:seed
```

### VPS Status
```bash
systemctl status nginx
sudo fail2ban-client status
sudo ufw status
sudo tail -f /var/log/auth.log
```

---

**Policy Repository**: /root/policies-repo/
**AI Job Tracker**: /root/AI_JOBS.md
**Last Updated**: 2026-01-14
