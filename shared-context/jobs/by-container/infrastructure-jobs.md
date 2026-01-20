# Infrastructure Jobs

**Scope:** Cross-container, system-level, VPS infrastructure
**Last Updated:** 2026-01-20

---

## Active Jobs

None currently.

---

## Pending Jobs

### [JOB-INF-001] Set GitHub Default Branch to Main
- **Status:** Pending
- **Priority:** Low
- **Assigned:** Manual task (requires GitHub UI)
- **Notes:** See manual_jobs.md Task 7

---

## Recently Completed

- [2026-01-20] Shared context system setup
  - Created `/root/policies-repo/shared-context/`
  - Set up 10-minute progress tracking cron
  - Created container documentation
  - Created job tracking structure

- [2026-01-14] Database backup automation
  - Script: `/usr/local/bin/backup-databases.sh`
  - Cron: Daily at 2 AM
  - Retention: 7 days

- [2026-01-14] Swap space configuration (4GB)

- [2026-01-14] System security hardening
  - fail2ban active
  - UFW firewall configured
  - Monarx agent running

---

## Recurring Tasks

| Task | Frequency | Last Run |
|------|-----------|----------|
| Database backups | Daily 2 AM | Auto |
| Progress updates | Every 10 min | Auto |
| Security checks | Weekly | Manual |

---

## Notes

- Infrastructure changes affect all services
- Always verify backups before major changes
- Document all system modifications
