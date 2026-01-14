# AI Agent Job Tracker - TEMPLATE

**Purpose:** Centralized task tracking for all AI agents working on a VPS
**Version:** 1.0
**Last Template Update:** 2026-01-14

> **📝 Note:** This is a TEMPLATE file. Copy it to `/root/AI_JOBS.md` on your VPS and customize with your specific tasks, services, and environment details.

---

## 📋 Instructions for AI Agents

### How to Use This Document

1. **READ this document** at the start of your session to understand pending work
2. **UPDATE this document** when you:
   - Complete a job (move to "Completed" section)
   - Discover new jobs (add to appropriate section)
   - Change job status or priority
   - Find important information/conclusions
3. **LOG your work** in the "Agent Activity Log" section at the bottom
4. **ALWAYS** update the "Last Updated" date at the top

### Update Format

When you complete a job:
```markdown
## Completed Jobs
- ✅ [Date] Job description
  - **Agent:** Your identifier (Claude/Gemini/Codex)
  - **Conclusions:** Key findings, decisions made, issues encountered
  - **Related files:** Paths to files created/modified
```

When you discover a new job:
```markdown
## [Appropriate Section]
- ⚠️ **[PRIORITY]** Job description
  - **Context:** Why this is needed
  - **Estimated effort:** Small/Medium/Large
```

---

## 🎯 MASTER ACTION PLAN & CHECKLIST

### Overview
[Describe your VPS hosting setup: number of services, development projects, current state]

### 🎨 Current State Summary
- ✅ **Working Services:** [List working services and domains]
- ⚠️ **Broken Services:** [List services that need attention]
- 🔧 **Development Projects:** [List projects in development]
- 🔒 **Security Risks:** [List known security issues]
- 💾 **Missing:** [List missing infrastructure: backups, monitoring, etc.]

---

### 📅 PHASE 1: Immediate (Do This Week)

#### Context
[Describe critical issues that need immediate attention]

#### Checklist

- [ ] **TASK 1.1: [Task Name]** [Time Estimate]
  - **Why:** [Business/technical reason]
  - **Impact:** HIGH/MEDIUM/LOW - [Impact description]
  - **Risk:** HIGH/MEDIUM/LOW - [Risk description]
  - **Dependencies:** [List dependencies or "None"]
  - **Steps:**
    ```bash
    # Step-by-step commands here
    # Command 1
    # Command 2
    ```
  - **Success Criteria:**
    - [Criterion 1]
    - [Criterion 2]
    - [Criterion 3]
  - **Log Results:** [Instructions for documenting completion]

- [ ] **TASK 1.2: [Task Name]** [Time Estimate]
  - **Why:** [Reason]
  - **Impact:** [Level] - [Description]
  - **Risk:** [Level] - [Description]
  - **Dependencies:** [List or "None"]
  - **Steps:**
    ```bash
    # Commands
    ```
  - **Success Criteria:**
    - [Criteria]
  - **Log Results:** [Instructions]

---

### 📅 PHASE 2: Important (Do This Month)

#### Context
[Describe important but not urgent work]

#### Checklist

- [ ] **TASK 2.1: Set Up Database Backups** [2 hours]
  - **Why:** No current backup strategy - data loss would be catastrophic
  - **Impact:** CRITICAL (for disaster recovery)
  - **Risk:** LOW - Script is read-only until tested
  - **Dependencies:** None
  - **Scope:**
    - [Database 1]
    - [Database 2]
    - [Data directory 1]
  - **Steps:**
    ```bash
    # 1. Create backup directory
    sudo mkdir -p /var/backups/databases
    sudo chmod 700 /var/backups/databases

    # 2. Create backup script
    sudo nano /usr/local/bin/backup-databases.sh
    ```
    **Script content:**
    ```bash
    #!/bin/bash
    BACKUP_DIR="/var/backups/databases"
    DATE=$(date +%Y%m%d_%H%M%S)

    # Add your backup commands here
    # Example: docker exec container-name pg_dump -U user dbname | gzip > $BACKUP_DIR/backup_$DATE.sql.gz

    # Remove backups older than 7 days
    find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

    echo "Backup completed: $DATE"
    ```
    ```bash
    # 3. Make executable
    sudo chmod +x /usr/local/bin/backup-databases.sh

    # 4. Test manually
    sudo /usr/local/bin/backup-databases.sh
    ls -lh /var/backups/databases/

    # 5. Set up cron (daily at 2 AM)
    sudo crontab -e
    # Add: 0 2 * * * /usr/local/bin/backup-databases.sh >> /var/log/backups.log 2>&1

    # 6. Test restoration process
    ```
  - **Success Criteria:**
    - Backup script runs without errors
    - Backup files created and compressed
    - Old backups automatically removed
    - Cron job scheduled
    - Restoration tested successfully
  - **Future Enhancement:** Copy backups to external storage (S3, Backblaze B2)
  - **Log Results:** Document backup schedule and retention policy

- [ ] **TASK 2.2: [Task Name]** [Time Estimate]
  - **Why:** [Reason]
  - **Impact:** [Level]
  - **Risk:** [Level]
  - **Dependencies:** [List]
  - **Steps:**
    ```bash
    # Commands
    ```
  - **Success Criteria:**
    - [Criteria]
  - **Log Results:** [Instructions]

---

### 📅 PHASE 3: Optimization (Do When Time Permits)

#### Context
[Describe nice-to-have improvements]

#### Checklist

- [ ] **TASK 3.1: Set Up Monitoring/Alerting** [2-3 hours]
  - **Why:** Proactive awareness prevents outages
  - **Impact:** MEDIUM - Early warning system
  - **Options:**
    - **A) External Monitoring (Recommended):**
      - UptimeRobot (free tier: 50 monitors, 5-min checks)
      - Monitor: [List your domains]
    - **B) Self-Hosted (Advanced):**
      - Netdata (real-time metrics)
      - Grafana + Prometheus (comprehensive)
  - **Steps for UptimeRobot:**
    ```bash
    # 1. Sign up at uptimerobot.com
    # 2. Add HTTP(S) monitors for each domain
    # 3. Configure alert contacts (email, Slack, etc.)
    # 4. Set up keyword monitoring (optional)
    # 5. Test alerts by stopping a service
    ```
  - **Success Criteria:**
    - All services monitored
    - Alerts delivered within 5 minutes
    - Historical uptime tracked
  - **Log Results:** Document monitoring setup

- [ ] **TASK 3.2: Weekly Security Checks** [Recurring - 15 minutes]
  - **Why:** Proactive security posture
  - **Frequency:** Weekly or bi-weekly
  - **Steps:**
    ```bash
    # 1. Check fail2ban status
    sudo fail2ban-client status

    # 2. Review auth logs for suspicious activity
    sudo tail -100 /var/log/auth.log | grep -i failed

    # 3. Review disk usage
    df -h

    # 4. Check service health
    docker ps -a
    sudo systemctl status [your-services]
    ```
  - **Success Criteria:**
    - No suspicious activity detected
    - All services healthy
    - Disk usage under 80%
  - **Log Results:** Note any issues for investigation

---

## 📊 Progress Tracking

### Completion Status

| Phase | Tasks | Completed | Progress |
|-------|-------|-----------|----------|
| Phase 1 (Immediate) | 0 | 0 | ░░░░░░░░░░ 0% |
| Phase 2 (Important) | 0 | 0 | ░░░░░░░░░░ 0% |
| Phase 3 (Optimization) | 0 | 0 | ░░░░░░░░░░ 0% |
| **TOTAL** | **0** | **0** | **░░░░░░░░░░ 0%** |

**Last Updated:** [Date]

### Quick Status Check
```bash
# Run this to check system health
echo "=== SERVICE STATUS ===" && \
docker ps --format "table {{.Names}}\t{{.Status}}" && \
echo -e "\n=== WEB SERVER STATUS ===" && \
sudo systemctl status [nginx/caddy/apache2] --no-pager -l && \
echo -e "\n=== DISK USAGE ===" && \
df -h / && \
echo -e "\n=== MEMORY USAGE ===" && \
free -h
```

---

## 🚨 Critical Jobs (Quick Reference)

> This section duplicates Phase 1 tasks for quick visibility

### 1. [Critical Task Name]
- **Status:** ⚠️ NOT STARTED
- **Priority:** HIGH
- **Location:** [Path]
- **Issue:** [Description]
- **Quick Fix:**
  ```bash
  # Commands to fix
  ```

---

## 🔒 Security & Hardening Jobs

### [Security Task Name]
- **Status:** 🟡 OPTIONAL / ⚠️ REQUIRED
- **Priority:** HIGH/MEDIUM/LOW
- **Current State:** [Description]
- **Action Required:**
  - [Step 1]
  - [Step 2]
- **Risk:** [Risk if not done]

---

## 💾 Backup & Monitoring Jobs

### [Backup Task Name]
- **Status:** ⚠️ NOT STARTED
- **Priority:** MEDIUM
- **Scope:** [What to backup]
- **Action Required:**
  - [Steps]

---

## 🚀 Development & Deployment Jobs

### [Dev Task Name]
- **Status:** ⚠️ NOT STARTED
- **Priority:** MEDIUM
- **Location:** [Path]
- **Current State:** [Status]
- **Action Required:**
  - [Steps]

---

## 🔍 Investigation & Documentation Jobs

### [Investigation Task Name]
- **Status:** ℹ️ INFO NEEDED
- **Priority:** LOW
- **Location:** [Path]
- **Action Required:**
  - [What to investigate]
  - [What to document]

---

## 📊 Monitoring & Maintenance Jobs

### [Recurring Task Name]
- **Status:** 🔄 RECURRING
- **Priority:** LOW
- **Frequency:** [When to run]
- **Action Required:**
  ```bash
  # Commands to run
  ```

---

## ✅ Completed Jobs

### Template Entry (Remove when adding real entries)
```markdown
- ✅ [YYYY-MM-DD] Task description
  - **Agent:** AI Agent Name
  - **Conclusions:** Key findings, decisions made, issues encountered
  - **Related files:** /path/to/file, /path/to/another
  - **Duration:** Actual time taken
  - **Issues:** Any problems encountered
  - **Next steps:** Follow-up tasks if any
```

---

## 🤖 Agent Activity Log

### Format
```markdown
**[YYYY-MM-DD HH:MM]** Agent Name (Model)
- Action: What you did
- Status: Success/Failure/In Progress
- Notes: Any important findings or issues
```

### Log Entries

**[YYYY-MM-DD HH:MM]** [Agent Name]
- Action: [Description]
- Status: [Status]
- Notes: [Details]

---

## 📚 Related Documentation

- **VPS Environment Report:** [Path to report]
- **Global Instructions:** [Path to AI agent instructions]
- **Policies Repository:** [Path to policies]
- **Other Documentation:**
  - [Doc 1]
  - [Doc 2]

---

## 🎯 Quick Reference

### Service Locations
- Service 1: [Path]
- Service 2: [Path]
- Service 3: [Path]

### Service Domains
- Service 1: [domain.example.com]
- Service 2: [domain2.example.com]

### Key Commands
```bash
# Service status
docker ps -a
sudo systemctl status [service-name]

# Logs
docker logs -f <container-name>
sudo journalctl -u [service] -f

# Security
sudo fail2ban-client status
sudo ufw status

# System health
df -h
free -h
docker stats
```

### Environment Details
- **OS:** [Ubuntu 24.04, etc.]
- **Web Server:** [Nginx/Caddy/Apache]
- **Database:** [PostgreSQL/MySQL/MongoDB]
- **Docker:** [Version]
- **Node.js:** [Version]

---

## 🔄 Syncing with Template

This file is based on the template at: `/root/policies-repo/AI_JOBS_TEMPLATE.md`

To sync updates from the template:
```bash
/root/sync-jobs.sh pull
```

To update the template with your structure (removes VPS-specific data):
```bash
/root/sync-jobs.sh push
```

---

**Remember:** Always update this document when you complete work or discover new tasks!

**Template Version:** 1.0
**Template Repository:** https://github.com/Coriatel/Policies-Instructions-and-Skills-.git
