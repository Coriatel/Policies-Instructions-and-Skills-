# Workflow Guide for AI Agents

**Purpose:** Comprehensive guide on exactly how and when to use each file in the shared-context system
**Applies to:** Claude, Codex, Gemini
**Location:** `/root/policies-repo/shared-context/WORKFLOW_GUIDE.md`
**Last Updated:** 2026-01-20

---

## Table of Contents

1. [Session Start Workflow](#session-start-workflow)
2. [Per-Prompt Workflow](#per-prompt-workflow)
3. [Session End Workflow](#session-end-workflow)
4. [File Responsibility Matrix](#file-responsibility-matrix)
5. [Update Frequency Rules](#update-frequency-rules)
6. [Cross-Agent Coordination](#cross-agent-coordination)
7. [Decision Flowcharts](#decision-flowcharts)
8. [Archival System](#archival-system)

---

## Session Start Workflow

```
+-------------------------------------------------------------+
|                      SESSION START                           |
+-------------------------------------------------------------+
| 1. READ (in order):                                         |
|    +-- GLOBAL_RULES.md (rules & safety)                     |
|    +-- VPS_STRUCTURE.md (container map)                     |
|    +-- WORKFLOW_GUIDE.md (this file - first time only)      |
|    +-- WEEKLY_PROGRESS.md (recent activity)                 |
|    +-- ERROR_LOG.md (recent errors to avoid)                |
|    +-- AI_JOBS.md (pending tasks)                           |
|                                                              |
| 2. CHECK:                                                    |
|    +-- docker ps (container health)                         |
|                                                              |
| 3. IDENTIFY:                                                 |
|    +-- Which containers does my task affect?                |
|    +-- Read relevant containers/*.md                        |
|                                                              |
| 4. VERIFY:                                                   |
|    +-- Any blocking errors in ERROR_LOG.md?                 |
|    +-- Any in-progress work I should know about?            |
+-------------------------------------------------------------+
```

### Session Start Checklist

- [ ] Read GLOBAL_RULES.md
- [ ] Read VPS_STRUCTURE.md
- [ ] Check WEEKLY_PROGRESS.md for recent activity
- [ ] Check ERROR_LOG.md for active errors
- [ ] Review AI_JOBS.md for pending tasks
- [ ] Run `docker ps` to verify container health
- [ ] Identify which containers my work affects

---

## Per-Prompt Workflow

```
+-------------------------------------------------------------+
|                      EACH PROMPT                             |
+-------------------------------------------------------------+
| BEFORE ACTING:                                               |
| +-- Identify containers affected by this task               |
| +-- Read relevant containers/*.md if working on service     |
| +-- Check AUTONOMOUS_PROTOCOL.md for permission level       |
| +-- If risky operation -> ask for confirmation              |
|                                                              |
| DURING WORK:                                                 |
| +-- Log errors IMMEDIATELY -> ERROR_LOG.md                  |
| +-- Update job status -> AI_JOBS.md (mark in_progress)      |
| +-- Document significant findings                           |
|                                                              |
| AFTER COMPLETING:                                            |
| +-- Mark task done -> AI_JOBS.md                            |
| +-- Update container docs if config changed -> containers/* |
| +-- Document any new errors -> ERROR_LOG.md                 |
| +-- Note findings in WEEKLY_PROGRESS.md (if significant)    |
+-------------------------------------------------------------+
```

### Permission Check Process

1. **Is this a read operation?** -> Proceed
2. **Is this creating new files?** -> Proceed
3. **Is this modifying existing code?** -> Check scope
4. **Is this a destructive operation?** -> ASK FOR CONFIRMATION
5. **Does this affect production?** -> ASK FOR CONFIRMATION

### When to Read Container Docs

Read `containers/<name>.md` when:
- Starting work on that service
- Troubleshooting that container
- Planning changes that might affect it
- Needing port/path information

---

## Session End Workflow

```
+-------------------------------------------------------------+
|                      SESSION END                             |
+-------------------------------------------------------------+
| 1. UPDATE AI_JOBS.md:                                       |
|    +-- Mark completed tasks as done                         |
|    +-- Add any discovered tasks                             |
|    +-- Update task status for in-progress items             |
|                                                              |
| 2. UPDATE WEEKLY_PROGRESS.md:                               |
|    +-- Add activity summary for this session                |
|    +-- Add handoff notes for next agent                     |
|    +-- Note any blockers or issues                          |
|                                                              |
| 3. UPDATE ERROR_LOG.md (if errors occurred):                |
|    +-- Log any new errors encountered                       |
|    +-- Update resolution status for existing errors         |
|    +-- Move resolved errors to archive section              |
|                                                              |
| 4. UPDATE container docs (if configs changed):              |
|    +-- Document any port changes                            |
|    +-- Document any new environment variables               |
|    +-- Document any path changes                            |
|                                                              |
| 5. GIT (if changes in shared-context/):                     |
|    +-- git add -A                                           |
|    +-- git commit -m "docs: update shared context"          |
|    +-- git push (to feature branch)                         |
+-------------------------------------------------------------+
```

### Handoff Notes Template

Add to WEEKLY_PROGRESS.md:
```markdown
### [YYYY-MM-DD HH:MM] Session Handoff - [Agent Name]
**Completed:**
- Task 1
- Task 2

**In Progress:**
- Task being worked on (status, blockers)

**Discovered Issues:**
- Issue that needs attention

**Next Steps:**
- Suggested next action for following agent
```

---

## File Responsibility Matrix

| File | Read When | Update When | Who Updates |
|------|-----------|-------------|-------------|
| **GLOBAL_RULES.md** | Session start | Rules change | Human/Admin |
| **VPS_STRUCTURE.md** | Session start; before container work | Containers added/removed/changed | Any agent |
| **DOCS_INDEX.md** | Need to find documentation | New docs added | Any agent |
| **AUTONOMOUS_PROTOCOL.md** | Before risky operations | Policies change | Human/Admin |
| **WORKFLOW_GUIDE.md** | Session start (first time) | Workflow changes | Human/Admin |
| **ERROR_LOG.md** | Session start; when errors occur | Errors encountered or resolved | Any agent |
| **WEEKLY_PROGRESS.md** | Session start | Every 10 min (auto) + manually | Cron + Any agent |
| **AI_JOBS.md** | Session start | Task start/complete/discovered | Any agent |
| **containers/*.md** | Before working on that container | Container config changes | Any agent |
| **jobs/by-container/*.md** | Before container-specific work | Tasks for container change | Any agent |
| **jobs/_active_jobs.md** | Quick job overview needed | Derived from AI_JOBS.md | Any agent |

---

## Update Frequency Rules

### Automatic Updates (Cron)

| Trigger | Action | File |
|---------|--------|------|
| Every 10 minutes | Timestamp update | WEEKLY_PROGRESS.md |
| Every 10 minutes | Checkpoint creation | /root/ai-progress/checkpoints/ |
| Daily 2 AM | Cleanup old checkpoints | /root/ai-progress/checkpoints/ |

### Manual Updates

| Trigger | Files to Update |
|---------|-----------------|
| Session start | Read all core files |
| Starting a task | AI_JOBS.md (mark in_progress) |
| Encountering error | ERROR_LOG.md immediately |
| Completing task | AI_JOBS.md, WEEKLY_PROGRESS.md |
| Modifying container | containers/*.md |
| Changing ports/structure | VPS_STRUCTURE.md |
| Session end | AI_JOBS.md, WEEKLY_PROGRESS.md |

---

## Cross-Agent Coordination

### How Agents Share Context

1. **WEEKLY_PROGRESS.md** - Provides handoff notes between sessions
2. **ERROR_LOG.md** - Prevents agents from repeating mistakes
3. **AI_JOBS.md** - Shows what's in progress/completed/pending
4. **Checkpoints** - Survive terminal disconnection (10-min intervals)

### Coordination Rules

1. **Always check for in-progress work** before starting a task
2. **Never assume** another agent completed something - verify
3. **Document your work** so others can pick up where you left off
4. **Mark tasks in_progress** when you start to avoid conflicts
5. **Use handoff notes** to communicate with future agents

### Conflict Prevention

- Check AI_JOBS.md for tasks marked "in_progress"
- Check WEEKLY_PROGRESS.md for recent agent activity
- If conflict detected, document it and proceed carefully
- Don't work on same container as another agent without coordination

---

## Decision Flowcharts

### Should I Ask for Confirmation?

```
Is this operation destructive?
    |
    +-- YES --> ASK FOR CONFIRMATION
    |
    +-- NO --> Does it modify production?
                   |
                   +-- YES --> ASK FOR CONFIRMATION
                   |
                   +-- NO --> Does it access credentials?
                                  |
                                  +-- YES --> ASK FOR CONFIRMATION
                                  |
                                  +-- NO --> PROCEED
```

### Which Files Do I Update?

```
Did I complete a task?
    |
    +-- YES --> Update AI_JOBS.md
    |
Did I encounter an error?
    |
    +-- YES --> Update ERROR_LOG.md
    |
Did I change container config?
    |
    +-- YES --> Update containers/*.md AND VPS_STRUCTURE.md (if ports changed)
    |
Is session ending?
    |
    +-- YES --> Update WEEKLY_PROGRESS.md with handoff notes
```

### Should I Read Container Docs?

```
Am I working on a specific service?
    |
    +-- YES --> Read containers/<service>.md
    |
    +-- NO --> Am I troubleshooting?
                   |
                   +-- YES --> Read relevant containers/*.md
                   |
                   +-- NO --> Skip container docs
```

---

## Quick Reference Commands

### System Health Check
```bash
# Container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Disk usage
df -h /

# Memory usage
free -m

# Recent checkpoint
ls -la /root/ai-progress/checkpoints/ | tail -5
```

### Job Status Check
```bash
# Quick job status
grep -E "^- \[" /root/AI_JOBS.md | head -20

# In-progress items
grep -E "\[in.?progress\]|\[IN.?PROGRESS\]" /root/AI_JOBS.md
```

### Error Check
```bash
# Active errors
grep -A2 "Active Errors" /root/policies-repo/shared-context/progress/ERROR_LOG.md

# Container errors
docker logs --tail 20 <container-name>
```

---

## Why This Workflow Works

| Principle | How It's Achieved |
|-----------|-------------------|
| **Consistency** | All agents follow same rules and update same files |
| **Safety** | Permission checks before risky operations |
| **Knowledge preservation** | Errors and solutions documented, not lost |
| **Continuity** | Any agent can pick up where another left off |
| **Visibility** | Progress tracked even if terminal closes |

---

## Archival System

### Overview

The archival system keeps active files clean by moving old items to archives after ~2 months.

```
/root/ai-progress/
├── archives/                    # Quarterly archives
│   ├── 2026-Q1.md              # Archive summary + links
│   ├── sessions/               # Archived session logs
│   └── progress/               # Archived progress files
├── progress-history/           # Bi-weekly progress snapshots
├── session_logs/               # Current session logs (< 2 months old)
├── checkpoints/                # 10-minute auto-checkpoints
└── scripts/
    ├── archive-old-items.sh    # Monthly archive script
    └── rotate-progress.sh      # Bi-weekly rotation script
```

### Bi-Weekly Progress Rotation

**Schedule:** 1st and 15th of each month at 3 AM (automatic via cron)

**What happens:**
1. Current `WEEKLY_PROGRESS.md` is saved to `/root/ai-progress/progress-history/`
2. New progress file is created with summary of previous period
3. Old file's key stats are preserved in "Previous Period Summary" section

**Manual trigger:**
```bash
/root/ai-progress/scripts/rotate-progress.sh          # Only if > 14 days old
/root/ai-progress/scripts/rotate-progress.sh --force  # Force rotation
```

### Monthly Archive (2-Month Rule)

**Schedule:** 1st of each month at 4 AM (automatic via cron)

**What gets archived (items > 60 days old):**
- Completed tasks from AI_JOBS.md (moved to "Completed Jobs" section)
- Resolved errors from ERROR_LOG.md
- Old session logs from `/root/ai-progress/session_logs/`
- Old progress files from `/root/ai-progress/progress-history/`

**Archive format:** Quarterly files (`2026-Q1.md`, `2026-Q2.md`, etc.)

**What stays in archive:**
- Summary table of what was archived and when
- Extracted summaries from old sessions
- Full archived files in subdirectories

**Manual trigger:**
```bash
/root/ai-progress/scripts/archive-old-items.sh
```

### Archive Summary in AI_JOBS.md

After archiving, a note is added to AI_JOBS.md:
```markdown
## 📦 Archive History

- **[2026-03-01] Archived:** 15 tasks, 8 errors, 12 sessions → See `/root/ai-progress/archives/2026-Q1.md`
```

### Finding Archived Information

1. **Check archive summary:** Look for `## 📦 Archive History` section in AI_JOBS.md
2. **Browse archives:** `/root/ai-progress/archives/`
3. **Search archived sessions:** `grep -r "keyword" /root/ai-progress/archives/sessions/`
4. **View progress history:** `ls -la /root/ai-progress/progress-history/`

### Cron Schedule Summary

| Job | Schedule | Script |
|-----|----------|--------|
| Progress update | Every 10 min | `/usr/local/bin/ai-progress-update.sh` |
| Database backup | Daily 2 AM | `/usr/local/bin/backup-databases.sh` |
| Progress rotation | 1st & 15th, 3 AM | `/root/ai-progress/scripts/rotate-progress.sh` |
| Archive old items | 1st monthly, 4 AM | `/root/ai-progress/scripts/archive-old-items.sh` |

### Agent Responsibilities for Archival

**DO:**
- Let automatic archival handle old items
- Check `## 📦 Archive History` for recently archived items
- Search archives if looking for old information

**DON'T:**
- Manually delete completed tasks (let archive script handle it)
- Manually move session logs (automated)
- Modify archive files directly

---

**Maintained by:** Human/Admin
**Used by:** All AI Agents (Claude, Codex, Gemini)
