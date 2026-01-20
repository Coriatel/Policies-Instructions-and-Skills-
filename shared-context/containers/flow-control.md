# Flow Control Service

**Status:** Production
**Domain:** flow.coriathost.cloud

---

## Containers

| Container | Image | Port | Health |
|-----------|-------|------|--------|
| flow-control-frontend | app-frontend | 8080 | - |
| flow-control-db | postgres:15-alpine | 5432 | healthy |

## Purpose

Main business application for flow control management. React frontend with PostgreSQL database.

---

## Directories

| Path | Purpose |
|------|---------|
| `/opt/flow-control/` | Main application directory |
| `/opt/flow-control/app/src/` | Source code |
| `/opt/flow-control/app/dist/` | Built frontend |

---

## Common Commands

```bash
# View logs
docker logs flow-control-frontend --tail 50
docker logs flow-control-db --tail 50

# Restart frontend
docker restart flow-control-frontend

# Database access
docker exec -it flow-control-db psql -U postgres

# Build frontend
cd /opt/flow-control/app && npm run build

# Check database health
docker exec flow-control-db pg_isready
```

---

## Dependencies

- **flow-control-db:** PostgreSQL database (required)
- **flow-auth:** Authentication service (for login)
- **Caddy:** Reverse proxy (external access)

---

## Backups

- **Schedule:** Daily at 2 AM
- **Location:** `/var/backups/databases/flow_control_*.sql.gz`
- **Retention:** 7 days

---

## Safety Notes

- Database contains business data
- Frontend changes require build step
- Always backup before schema changes
- Test in development before production
