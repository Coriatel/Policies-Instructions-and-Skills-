# n8n Automation Service

**Status:** Production
**Domain:** n8n.coriathost.cloud

---

## Container

| Container | Image | Port | Health |
|-----------|-------|------|--------|
| n8n | n8nio/n8n:latest | 5678 | - |

## Purpose

Workflow automation platform. Creates automated workflows connecting various services and APIs.

---

## Directories

| Path | Purpose |
|------|---------|
| `/home/elron/services/n8n/` | n8n data directory |
| `/home/elron/services/n8n/.n8n/` | Database and config |

---

## Common Commands

```bash
# View logs
docker logs n8n --tail 50

# Restart service
docker restart n8n

# Check if running
docker ps | grep n8n

# View workflows (via logs)
docker logs n8n 2>&1 | grep -i workflow
```

---

## Backups

- **Schedule:** Daily at 2 AM
- **Location:** `/var/backups/databases/n8n_data_*.tar.gz`
- **Retention:** 7 days

---

## Access

- **URL:** https://n8n.coriathost.cloud
- **Auth:** Password protected (secured)

---

## Safety Notes

- Workflows can trigger external actions (emails, API calls)
- Activating workflows may have immediate effects
- Review workflow logic before enabling
- Test workflows in inactive mode first
- Password was recently secured (check COMPLETED jobs)

---

## Skills Reference

See `/root/policies-repo/skills/n8n-automation/` for:
- Workflow creation patterns
- Integration examples
- Best practices
