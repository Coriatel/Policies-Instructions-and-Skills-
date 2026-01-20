# Shared Context for AI Agents

**Purpose:** Unified context and rules for Claude, Codex, and Gemini CLI tools on this VPS.
**Location:** `/root/policies-repo/shared-context/`
**GitHub:** Part of Policies-Instructions-and-Skills repository

---

## Quick Start for AI Agents

At session start, read these files in order:

1. **GLOBAL_RULES.md** - Universal rules all agents must follow
2. **VPS_STRUCTURE.md** - Container and directory map
3. **WORKFLOW_GUIDE.md** - How and when to use each file (first time / reference)
4. **progress/WEEKLY_PROGRESS.md** - Current week's activity and handoff notes
5. **progress/ERROR_LOG.md** - Recent errors to avoid repeating
6. **/root/AI_JOBS.md** - Pending tasks and job tracker

For detailed workflow instructions, see **WORKFLOW_GUIDE.md**.

---

## Directory Structure

```
shared-context/
├── README.md                    # This file
├── GLOBAL_RULES.md              # Universal AI agent rules
├── VPS_STRUCTURE.md             # Container/directory documentation
├── DOCS_INDEX.md                # Where to find everything
├── AUTONOMOUS_PROTOCOL.md       # Safe autonomous execution rules
├── WORKFLOW_GUIDE.md            # Comprehensive workflow instructions
│
├── containers/                  # Per-container documentation
│   ├── flow-control.md          # Flow Control app + DB + Auth
│   ├── vtiger.md                # Both Vtiger instances
│   ├── n8n.md                   # n8n automation
│   ├── crmlite.md               # CRM Lite
│   ├── uptime-kuma.md           # Monitoring
│   └── flow-auth.md             # Auth service
│
├── jobs/                        # Container-specific job tracking
│   ├── _active_jobs.md          # Aggregated view of all active jobs
│   └── by-container/            # Jobs organized by container
│
└── progress/                    # Progress tracking
    ├── WEEKLY_PROGRESS.md       # Auto-updated every 10 minutes
    ├── ERROR_LOG.md             # Centralized error tracking
    └── archive/                 # Past weeks
```

---

## Key Principles

1. **Read before acting** - Always check VPS_STRUCTURE.md before modifying services
2. **Update as you go** - Log progress in WEEKLY_PROGRESS.md and AI_JOBS.md
3. **Follow protocols** - AUTONOMOUS_PROTOCOL.md defines what's safe to do
4. **Container awareness** - Know which containers your changes affect

---

## Related Files

| File | Location | Purpose |
|------|----------|---------|
| AI Job Tracker | `/root/AI_JOBS.md` | Main task list |
| Manual Jobs | `/root/manual_jobs.md` | Tasks requiring human action |
| Claude Config | `/root/CLAUDE.md` | Claude-specific instructions |
| Codex Config | `/root/.codex/instructions.md` | Codex-specific instructions |
| Gemini Config | `/root/.gemini/GEMINI.md` | Gemini-specific instructions |
| Skills Index | `/root/policies-repo/skills/INDEX-CLAUDE.md` | Available skills |

---

**Last Updated:** 2026-01-20 (Added WORKFLOW_GUIDE.md and ERROR_LOG.md)
