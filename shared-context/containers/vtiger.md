# Vtiger CRM Services

**Status:** Production
**Domain:** crmvtiger.coriathost.cloud (main instance)

---

## Containers

### Main Instance
| Container | Image | Port | Health |
|-----------|-------|------|--------|
| vtiger-app | javanile/vtiger:latest | 8083 | - |
| vtiger-mysql | mariadb:10.3 | - | healthy |

### Secure Instance
| Container | Image | Port | Health |
|-----------|-------|------|--------|
| vtiger-secure-app | vtiger-secure-vtiger | 8084 | - |
| vtiger-secure-db | mariadb:10.11 | - | healthy |

## Purpose

Customer Relationship Management (CRM) system. Two instances:
- **Main:** General CRM usage
- **Secure:** Enhanced security instance

---

## Directories

| Path | Purpose |
|------|---------|
| `/root/vtiger/` | Main instance config |
| `/root/vtiger-secure/` | Secure instance config |
| `/root/vtiger/custom/` | Custom scripts |

---
## Hebrew + RTL

Main instance includes Hebrew language pack and RTL overrides:
- vlayout (legacy): `/root/vtiger/custom/Header.tpl` + `/root/vtiger/custom/rtl.css`
- v7 UI: `/root/vtiger/custom/HeaderV7.tpl` + `/root/vtiger/custom/rtl-v7.css`

Mounted paths:
- `HeaderV7.tpl` -> `/var/www/html/layouts/v7/modules/Vtiger/Header.tpl`
- `rtl-v7.css` -> `/var/www/html/layouts/v7/skins/rtl.css`

---

## Common Commands

```bash
# View logs
docker logs vtiger-app --tail 50
docker logs vtiger-secure-app --tail 50

# Database access (main)
docker exec -it vtiger-mysql mysql -u root -p

# Database access (secure)
docker exec -it vtiger-secure-db mysql -u root -p

# Restart instances
docker restart vtiger-app vtiger-mysql
docker restart vtiger-secure-app vtiger-secure-db

# Check database health
docker exec vtiger-mysql mysqladmin ping
docker exec vtiger-secure-db mysqladmin ping
```

---

## Dependencies

- **vtiger-mysql:** MariaDB database (main)
- **vtiger-secure-db:** MariaDB database (secure)
- **Caddy:** Reverse proxy (external access)

---

## Cron Jobs

```bash
# ILS Rate Update (nightly)
/root/vtiger/custom/update-ils-rate.sh
```

---

## Safety Notes

- Contains real customer data
- Database changes require extreme caution
- Both instances share similar structure
- Hebrew language pack installed
- Backup before any modifications
