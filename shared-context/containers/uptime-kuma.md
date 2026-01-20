# Uptime Kuma Monitoring

**Status:** Production
**Domain:** uptime.coriathost.cloud (if configured)

---

## Container

| Container | Image | Port | Health |
|-----------|-------|------|--------|
| uptime-kuma | louislam/uptime-kuma:latest | 3002 | healthy |

## Purpose

Self-hosted monitoring tool. Tracks uptime of services and sends alerts on downtime.

---

## Directories

| Path | Purpose |
|------|---------|
| `/opt/uptime-kuma/` | Application data |

---

## Common Commands

```bash
# View logs
docker logs uptime-kuma --tail 50

# Restart service (caution: may trigger alerts)
docker restart uptime-kuma

# Check health
docker inspect uptime-kuma --format='{{.State.Health.Status}}'
```

---

## Access

- **URL:** http://127.0.0.1:3002 (internal)
- **External:** Via Caddy if configured

---

## Monitored Services

Check the Uptime Kuma dashboard for current monitors. Typically includes:
- Flow Control (flow.coriathost.cloud)
- n8n (n8n.coriathost.cloud)
- CRM Lite (crmlite.coriathost.cloud)
- Vtiger (crmvtiger.coriathost.cloud)

---

## Safety Notes

- Restarting may trigger false "down" alerts
- Prefer maintenance windows for restarts
- Deleting monitors loses historical data
- Configure notification channels carefully (avoid spam)

---

## Alert Channels

Notifications can be configured for:
- Email
- Telegram
- Slack
- Discord
- And many more

Check dashboard for current configuration.
