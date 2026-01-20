# CRM Lite Jobs

**Container:** crmlite-web
**Last Updated:** 2026-01-20

---

## Active Jobs

None currently.

---

## Pending Jobs

### [JOB-CRM-001] Firebase Key Rotation
- **Status:** Pending
- **Priority:** Medium
- **Assigned:** Manual task (requires Firebase console)
- **Dependencies:** Firebase console access
- **Notes:** See manual_jobs.md Task 1
- **Steps:**
  1. Access Firebase console
  2. Generate new API keys
  3. Update application configuration
  4. Rebuild and deploy

---

## Recently Completed

- [2026-01-14] Build and deployment fix (404 resolution)

---

## Notes

- Static frontend served by Caddy
- Build process: `cd /home/elron/services/crm-lite/crm-app && npm run build`
- Firebase integration for backend services
