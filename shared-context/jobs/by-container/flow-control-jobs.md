# Flow Control Jobs

**Containers:** flow-control-frontend, flow-control-db, flow-auth
**Last Updated:** 2026-01-20

---

## Active Jobs

None currently.

---

## Pending Jobs

None currently.

---

## Recently Completed

- [2026-01-14] Initial deployment and configuration
- [2026-01-14] Database backup automation setup

---

## Job Template

```markdown
### [JOB-FC-XXX] Job Title
- **Status:** Pending | In Progress | Blocked | Completed
- **Priority:** Critical | High | Medium | Low
- **Assigned:** Agent name or Unassigned
- **Created:** YYYY-MM-DD
- **Dependencies:** List any blockers
- **Files:**
  - /path/to/affected/file
- **Steps:**
  1. Step one
  2. Step two
- **Success Criteria:**
  - [ ] Criterion one
  - [ ] Criterion two
```

---

## Notes

- Main business application - changes affect users
- Always test before deploying to production
- Database backups run daily at 2 AM
