# CRM Lite Service

**Status:** Production
**Domain:** crmlite.coriathost.cloud

---

## Container

| Container | Image | Port | Health |
|-----------|-------|------|--------|
| crmlite-web | caddy:2 | 8090 | - |

## Purpose

Lightweight CRM application. Static frontend served by Caddy.

---

## Directories

| Path | Purpose |
|------|---------|
| `/home/elron/services/crm-lite/` | Application root |
| `/home/elron/services/crm-lite/crm-app/` | Source code |
| `/home/elron/services/crm-lite/crm-app/dist/` | Built frontend |

---

## Common Commands

```bash
# View logs
docker logs crmlite-web --tail 50

# Restart service
docker restart crmlite-web

# Build application
cd /home/elron/services/crm-lite/crm-app && npm run build

# Check build output
ls -la /home/elron/services/crm-lite/crm-app/dist/
```

---

## Build Process

```bash
# 1. Navigate to app
cd /home/elron/services/crm-lite/crm-app

# 2. Install dependencies (if needed)
npm install

# 3. Build for production
npm run build

# 4. Verify dist/ created
ls -la dist/

# 5. Test access
curl -I https://crmlite.coriathost.cloud
```

---

## Dependencies

- **Caddy:** Container serves static files
- No database dependency (static frontend)

---

## Safety Notes

- Static site - low risk
- Build errors won't affect running site
- Only dist/ changes affect live site
- Firebase integration may need key rotation (see manual_jobs.md)
