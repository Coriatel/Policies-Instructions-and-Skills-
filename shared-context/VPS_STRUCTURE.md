# VPS Structure Documentation

**Provider:** Hostinger VPS
**OS:** Ubuntu 24.04.3 LTS
**IP:** 72.62.59.160
**Reverse Proxy:** Caddy
**Last Updated:** 2026-01-20

---

## Container Map

### Production Services

| Service | Container | Image | Port | Domain |
|---------|-----------|-------|------|--------|
| Flow Control Frontend | flow-control-frontend | app-frontend | 8080 | flow.coriathost.cloud |
| Flow Control DB | flow-control-db | postgres:15-alpine | 5432 | - |
| Flow Auth | flow-auth | flow-auth-flow-auth | 8081 | - |
| n8n | n8n | n8nio/n8n:latest | 5678 | n8n.coriathost.cloud |
| CRM Lite | crmlite-web | caddy:2 | 8090 | crmlite.coriathost.cloud |
| Uptime Kuma | uptime-kuma | louislam/uptime-kuma:latest | 3002 | uptime.coriathost.cloud |
| Vtiger | vtiger-app | javanile/vtiger:latest | 8083 | crmvtiger.coriathost.cloud |
| Vtiger DB | vtiger-mysql | mariadb:10.3 | - | - |
| Vtiger Secure | vtiger-secure-app | vtiger-secure-vtiger | 8084 | - |
| Vtiger Secure DB | vtiger-secure-db | mariadb:10.11 | - | - |

### Service Dependencies

```
flow-control-frontend
    └── flow-control-db (PostgreSQL)
    └── flow-auth (Authentication)

vtiger-app
    └── vtiger-mysql (MariaDB)

vtiger-secure-app
    └── vtiger-secure-db (MariaDB)

n8n (standalone)
crmlite-web (standalone - static files)
uptime-kuma (standalone)
```

---

## Directory Structure

### /root/ (AI Agent Workspace)

```
/root/
├── AI_JOBS.md              # Central job tracker
├── manual_jobs.md          # Human tasks
├── CLAUDE.md               # Claude CLI instructions
├── Caddyfile               # Reverse proxy config
├── VPS_ENVIRONMENT_REPORT.md  # System documentation
│
├── policies-repo/          # Git: Policies & Skills (434MB)
│   ├── shared-context/     # THIS DIRECTORY
│   ├── skills/             # Execution guides
│   ├── .cursor/rules/      # Cursor IDE policies
│   ├── apps/               # CRM platform code
│   └── docs/               # Documentation
│
├── vtiger/                 # Vtiger config (88KB)
├── vtiger-secure/          # Secure Vtiger config (88KB)
├── flow-auth/              # Auth service (2.4MB)
├── expiry-alert/           # Expiry alert app (1.5GB)
│
├── .claude/                # Claude CLI config
├── .codex/                 # Codex CLI config
├── .gemini/                # Gemini CLI config
└── ai-progress/            # Local progress tracking
```

### /home/elron/services/ (User Services)

```
/home/elron/services/
├── charity/                # Give/Charity static site
├── crm-lite/               # CRM Lite application
│   └── crm-app/
│       └── dist/           # Built frontend
└── n8n/                    # n8n data directory
```

### /opt/ (System Services)

```
/opt/
├── flow-control/           # Flow Control application
│   └── app/
│       ├── src/
│       └── dist/
├── uptime-kuma/            # Uptime Kuma data
└── containerd/             # Container runtime
```

### /var/backups/ (Backup Storage)

```
/var/backups/
└── databases/              # Daily DB backups (7-day retention)
    ├── flow_control_YYYYMMDD_HHMMSS.sql.gz
    └── n8n_data_YYYYMMDD_HHMMSS.tar.gz
```

---

## Network Configuration

### Caddy Reverse Proxy

**Config:** `/etc/caddy/Caddyfile`

| Domain | Backend | Notes |
|--------|---------|-------|
| flow.coriathost.cloud | 127.0.0.1:8080 | Flow Control |
| n8n.coriathost.cloud | 127.0.0.1:5678 | n8n |
| crmlite.coriathost.cloud | 127.0.0.1:8090 | CRM Lite |
| give.coriathost.cloud | /home/elron/services/charity | Static |
| crmvtiger.coriathost.cloud | 127.0.0.1:8083 | Vtiger |

### Internal Ports

| Port | Service | Access |
|------|---------|--------|
| 3001 | Policies-repo CRM API | PM2 managed |
| 3002 | Uptime Kuma | Container |
| 5432 | PostgreSQL | Container (flow-control-db) |
| 5678 | n8n | Container |
| 8080 | Flow Control Frontend | Container |
| 8081 | Flow Auth | Container |
| 8083 | Vtiger | Container |
| 8084 | Vtiger Secure | Container |
| 8090 | CRM Lite | Container |

### Firewall (UFW)

```
Status: active
22/tcp    ALLOW   (SSH)
80/tcp    ALLOW   (HTTP)
443/tcp   ALLOW   (HTTPS)
```

---

## System Resources

| Resource | Value |
|----------|-------|
| RAM | 8GB (1.5GB used) |
| Disk | 96GB (17% used) |
| Swap | 4GB |
| CPU | Shared VPS |

---

## Backup Schedule

**Script:** `/usr/local/bin/backup-databases.sh`
**Schedule:** Daily at 2:00 AM UTC
**Retention:** 7 days
**Log:** `/var/log/backups.log`

**Backed up:**
- flow-control-db (PostgreSQL)
- n8n data volume

---

## Security Services

| Service | Status | Notes |
|---------|--------|-------|
| fail2ban | Active | SSH protection |
| UFW | Active | Firewall |
| Monarx | Active | Malware scanning |
| Caddy | Active | Auto HTTPS |

---

## Quick Commands

```bash
# View all containers
docker ps -a

# Check specific service
docker logs flow-control-frontend --tail 50

# Restart service
docker restart <container-name>

# Check Caddy config
cat /etc/caddy/Caddyfile

# View recent backups
ls -la /var/backups/databases/

# Check disk usage
df -h

# Check memory
free -m
```
