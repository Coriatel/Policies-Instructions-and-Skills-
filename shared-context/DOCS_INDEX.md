# Documentation Index

**Purpose:** Quick reference for finding documentation and configuration files.
**Last Updated:** 2026-01-21

---

## AI Agent Configuration

| Agent | Instructions | Skills Index | Config Dir |
|-------|-------------|--------------|------------|
| Claude | `/root/CLAUDE.md` | `/root/policies-repo/skills/INDEX-CLAUDE.md` | `/root/.claude/` |
| Codex | `/root/.codex/instructions.md` | `/root/.codex/skills/` | `/root/.codex/` |
| Gemini | `/root/.gemini/GEMINI.md` | `/root/policies-repo/skills/INDEX-GEMINI.md` | `/root/.gemini/` |

---

## Job Tracking

| File | Purpose | Location |
|------|---------|----------|
| AI Jobs | Main task tracker | `/root/AI_JOBS.md` |
| Manual Jobs | Human-required tasks | `/root/manual_jobs.md` |
| Active Jobs | Aggregated active view | `/root/policies-repo/shared-context/jobs/_active_jobs.md` |
| Weekly Progress | Auto-updated progress | `/root/policies-repo/shared-context/progress/WEEKLY_PROGRESS.md` |
| Job Template | Template for new VPS | `/root/policies-repo/AI_JOBS_TEMPLATE.md` |
| Sync Script | Multi-VPS sync | `/root/sync-jobs.sh` |

---

## Shared Context

| File | Purpose |
|------|---------|
| `shared-context/GLOBAL_RULES.md` | Universal AI agent rules |
| `shared-context/VPS_STRUCTURE.md` | Container and directory map |
| `shared-context/DOCS_INDEX.md` | This file |
| `shared-context/AUTONOMOUS_PROTOCOL.md` | Safe autonomy guidelines |

---

## Architecture & Design

| Document | Location |
|----------|----------|
| CRM Architecture | `/root/policies-repo/docs/ARCHITECTURE.md` |
| Policy Architecture | `/root/policies-repo/docs/ARCHITECTURE_OF_POLICIES.md` |
| Contributing Guide | `/root/policies-repo/docs/CONTRIBUTING.md` |
| Design Assumptions | `/root/policies-repo/docs/ASSUMPTIONS.md` |

---

## Operations Runbooks

| Document | Location |
|----------|----------|
| VPS Runbook | `/root/policies-repo/docs/ops/HOSTINGER_VPS_RUNBOOK.md` |
| Security Protocol | `/root/policies-repo/docs/ops/HOSTINGER_SECURITY_PROTOCOL.md` |
| Malware Response | `/root/policies-repo/docs/ops/HOSTINGER_MALWARE_RESPONSE.md` |
| Terminal/SSH Policy | `/root/policies-repo/docs/ops/TERMINAL_SSH_POLICY.md` |
| Ubuntu Hardening | `/root/policies-repo/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md` |
| WordPress Hardening | `/root/policies-repo/docs/ops/HOSTINGER_WORDPRESS_HARDENING.md` |
| AI Agent Safety | `/root/policies-repo/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md` |

---

## Agent-Specific Instructions

| Agent | Snapshot |
|-------|----------|
| Claude | `/root/policies-repo/docs/ops/agent-instructions/CLAUDE.md` |
| Codex | `/root/policies-repo/docs/ops/agent-instructions/CODEX.md` |
| Gemini | `/root/policies-repo/docs/ops/agent-instructions/GEMINI.md` |

---

## Skills Library

**Location:** `/root/policies-repo/skills/`

### Core Skills (Directories)
| Skill | Path |
|-------|------|
| UI Components | `/root/policies-repo/skills/ui/` |
| API Express | `/root/policies-repo/skills/api-express/` |
| Auth RBAC | `/root/policies-repo/skills/auth-rbac/` |
| Prisma/Postgres | `/root/policies-repo/skills/prisma-postgres/` |
| Testing E2E | `/root/policies-repo/skills/testing-e2e/` |
| CI/CD | `/root/policies-repo/skills/ci-cd/` |
| n8n Automation | `/root/policies-repo/skills/n8n-automation/` |
| Hostinger Ops | `/root/policies-repo/skills/hostinger-vps-ops/` |
| RTL/Hebrew | `/root/policies-repo/skills/rtl-hebrew/` |
| Terminal/SSH | `/root/policies-repo/skills/terminal-ssh-vps/` |
| PRD Creator | `/root/policies-repo/skills/prd-creator/` |
| Skill Maker | `/root/policies-repo/skills/skill-maker/` |

### Quick Reference Skills (Files)
| Skill | Path |
|-------|------|
| Add React Page | `/root/policies-repo/skills/add-react-page.md` |
| Add API Route | `/root/policies-repo/skills/add-api-route.md` |
| Database Migration | `/root/policies-repo/skills/database-migration.md` |
| Deployment | `/root/policies-repo/skills/deployment.md` |
| Getting Started | `/root/policies-repo/skills/getting-started.md` |
| RBAC Setup | `/root/policies-repo/skills/rbac-setup.md` |
| Testing | `/root/policies-repo/skills/testing.md` |

---

## Cursor IDE Policies

**Location:** `/root/policies-repo/.cursor/rules/`

| Policy | File |
|--------|------|
| Overview | `000-overview.md` |
| Code Style (JS) | `010-code-style-js.md` |
| UI/React/SCSS | `020-ui-react-scss-a11y.md` |
| RTL/Hebrew | `030-rtl-hebrew.md` |
| Tables/Forms | `040-tables-forms.md` |
| API/Express | `050-api-express.md` |
| Auth/RBAC | `060-auth-rbac.md` |
| Prisma/Postgres | `070-prisma-postgres.md` |
| Testing | `080-testing-e2e.md` |
| Git Workflow | `090-git-workflow.md` |
| Security | `100-security-secrets.md` |
| Hostinger Compliance | `110-hostinger-vps-compliance.md` |
| Skills Index | `120-skills-index.md` |

---

## Service-Specific Docs

| Service | Documentation |
|---------|--------------|
| Flow Control | `/opt/flow-control/app/docs/` |
| n8n | `/root/policies-repo/skills/n8n-automation/` |
| Vtiger | `/root/vtiger/` (config only) |
| CRM Lite | `/home/elron/services/crm-lite/` |

---

## Configuration Files

| Purpose | Location |
|---------|----------|
| Caddy Config | `/etc/caddy/Caddyfile` |
| Backup Script | `/usr/local/bin/backup-databases.sh` |
| Backup Log | `/var/log/backups.log` |
| Monthly Security Update Script | `/usr/local/bin/monthly-security-update.sh` |
| Monthly Security Update Log | `/var/log/monthly-update.log` |
| Monthly Security Update Cron | `/etc/cron.d/monthly-security-update` |
| Progress Script | `/usr/local/bin/ai-progress-update.sh` |
| Progress Log | `/var/log/ai-progress.log` |
| Docker Compose | Per-service directories |

---

## GitHub Repository

**URL:** https://github.com/Coriatel/Policies-Instructions-and-Skills-.git
**Branch:** main
**Contains:** All policies, skills, documentation, CRM platform code
