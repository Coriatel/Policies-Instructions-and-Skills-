# Flow Auth Service

**Status:** Production
**Domain:** Internal only (via flow-control)

---

## Container

| Container | Image | Port | Health |
|-----------|-------|------|--------|
| flow-auth | flow-auth-flow-auth | 8081 | - |

## Purpose

Authentication service for Flow Control application. Handles login, registration, JWT tokens, and session management.

---

## Directories

| Path | Purpose |
|------|---------|
| `/root/flow-auth/` | Service source code |

---

## Common Commands

```bash
# View logs
docker logs flow-auth --tail 50

# Restart service
docker restart flow-auth

# Check if running
docker ps | grep flow-auth

# View environment
docker exec flow-auth env | grep -v SECRET
```

---

## Dependencies

- **flow-control-db:** Shares database with flow-control
- **flow-control-frontend:** Consumes auth API

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/auth/login` | POST | User login |
| `/auth/register` | POST | User registration |
| `/auth/refresh` | POST | Refresh JWT token |
| `/auth/logout` | POST | Logout user |

---

## Safety Notes

- Handles sensitive authentication data
- JWT secrets must never be exposed
- Changes affect all authenticated users
- Test thoroughly before deploying changes
