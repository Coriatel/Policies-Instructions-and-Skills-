# Error Log

**Purpose:** Track all errors encountered across all AI agent sessions
**Location:** `/root/policies-repo/shared-context/progress/ERROR_LOG.md`
**Last Updated:** 2026-01-20

---

## Why This File Exists

1. **Prevent repeating mistakes** - Document errors so no agent makes the same mistake twice
2. **Document solutions** - Record what worked so future agents can reference it
3. **Enable cross-agent learning** - All agents share this knowledge base
4. **Provide troubleshooting reference** - Quick lookup for common issues

---

## Active Errors (Unresolved)

| ID | Date | Agent | Container | Error Summary | Status |
|----|------|-------|-----------|---------------|--------|
| — | — | — | — | No active errors | — |

---

## How to Log Errors

When you encounter an error:

1. **Add to Active Errors table** with a new ID (ERR-XXX)
2. **Create a detailed entry** below using the template
3. **Update status** when resolved or if you find more information
4. **Move to Resolved Archive** when fully fixed

### Error ID Format
- Use sequential numbering: ERR-001, ERR-002, etc.
- Check the highest existing ID and increment

---

## Error Details

### Template for New Errors

```markdown
### [ERR-XXX] Error Title
- **Date:** YYYY-MM-DD
- **Agent:** Claude/Codex/Gemini
- **Container:** affected-container (or "System" or "None")
- **Category:** Container | System | Code | Network | Database | Permission | Config
- **Severity:** Critical | High | Medium | Low
- **Error Message:**
  ```
  Exact error text here
  ```
- **Context:** What was being attempted when this occurred
- **Root Cause:** Why it happened (if known)
- **Solution:** How it was fixed (if resolved)
- **Prevention:** How to avoid this in future
- **Status:** Resolved | In Progress | Needs Human | Blocked
- **Related Files:** Paths to relevant files
```

---

## Severity Definitions

| Severity | Definition | Response |
|----------|------------|----------|
| Critical | Production down, data loss risk | Stop immediately, alert human |
| High | Service degraded, blocking work | Prioritize fixing |
| Medium | Inconvenient but workaround exists | Fix when possible |
| Low | Minor issue, cosmetic | Log and continue |

---

## Category Definitions

| Category | Examples |
|----------|----------|
| Container | Docker errors, container crashes, networking between containers |
| System | Disk full, memory issues, process crashes, cron failures |
| Code | Syntax errors, runtime exceptions, failed builds |
| Network | DNS issues, SSL errors, port conflicts, firewall blocks |
| Database | Connection failures, query errors, migration issues |
| Permission | Access denied, ownership issues, sudo requirements |
| Config | Missing env vars, wrong paths, misconfiguration |

---

## Resolved Errors Archive

*Move resolved errors here after they've been fixed and documented.*

### [ERR-000] Example: Template Error Entry (Reference Only)
- **Date:** 2026-01-20
- **Agent:** Claude
- **Container:** None (template)
- **Category:** Config
- **Severity:** Low
- **Error Message:**
  ```
  This is an example error message
  ```
- **Context:** This is a template entry to demonstrate the format
- **Root Cause:** N/A - template only
- **Solution:** Use this format for real errors
- **Prevention:** Follow the template consistently
- **Status:** Resolved
- **Related Files:** `/root/policies-repo/shared-context/progress/ERROR_LOG.md`

---

## Quick Reference: Common Errors and Solutions

### Container Won't Start
- Check logs: `docker logs <container-name> --tail 100`
- Check ports: `docker ps -a` and `netstat -tlnp | grep <port>`
- Check disk space: `df -h`

### Permission Denied
- Check ownership: `ls -la <path>`
- Check if sudo needed
- Check container user vs host user

### Connection Refused
- Container running? `docker ps`
- Port bound? `netstat -tlnp`
- Firewall? `sudo ufw status`

### Out of Memory
- Check: `free -m` and `docker stats`
- Clear logs: `sudo journalctl --vacuum-size=100M`
- Restart problematic container

---

**Maintained by:** All AI Agents (Claude, Codex, Gemini)
**Review:** Human review recommended for Critical/High severity items
