# AI_JOBS.md Sync System Documentation

**Purpose:** Manage AI agent job tracking across multiple VPS servers with a shared template in Git.

---

## 🎯 Overview

The AI_JOBS.md sync system allows you to:
- ✅ Keep a **local VPS-specific** job list at `/root/AI_JOBS.md`
- ✅ Maintain a **generic template** in Git at `AI_JOBS_TEMPLATE.md`
- ✅ Sync structure updates between them
- ✅ Share the template across multiple VPS servers
- ✅ Version control the template structure

---

## 📂 File Structure

```
/root/
├── AI_JOBS.md              # Local VPS-specific job list (NOT in git)
└── sync-jobs.sh            # Sync script

/root/policies-repo/
├── AI_JOBS_TEMPLATE.md     # Template structure (IN git)
└── docs/
    └── AI_JOBS_SYNC.md     # This documentation

/root/.job-backups/
└── AI_JOBS_YYYYMMDD_HHMMSS.md  # Automatic backups
```

---

## 🔄 How It Works

### Local File (`/root/AI_JOBS.md`)
- **Contains:** Your actual VPS-specific tasks, domains, paths, progress
- **Location:** `/root/` (outside git repo)
- **Updates:** AI agents update this directly as they work
- **Backup:** Automatically backed up before sync operations

### Template File (`AI_JOBS_TEMPLATE.md`)
- **Contains:** Structure, instructions, placeholder examples
- **Location:** Inside git repo (`/root/policies-repo/`)
- **Updates:** When you want to share structure improvements
- **Version Control:** Tracked in Git, can be pulled/pushed

### Sync Script (`/root/sync-jobs.sh`)
- **Purpose:** Transfer updates between local and template
- **Safety:** Creates backups before operations
- **Intelligence:** Sanitizes VPS-specific data when pushing

---

## 🚀 Quick Start

### Initial Setup (New VPS)

```bash
# 1. Clone policies repo
cd /root
git clone https://github.com/Coriatel/Policies-Instructions-and-Skills-.git policies-repo

# 2. Copy sync script
cp /root/policies-repo/scripts/sync-jobs.sh /root/
chmod +x /root/sync-jobs.sh

# 3. Create local file from template
/root/sync-jobs.sh pull

# 4. Customize local file with your VPS details
nano /root/AI_JOBS.md
# Update domains, paths, services, tasks, etc.
```

### Existing VPS (Already has AI_JOBS.md)

```bash
# Just ensure sync script is in place
chmod +x /root/sync-jobs.sh

# Check status
/root/sync-jobs.sh status
```

---

## 📖 Usage Guide

### Check Sync Status
```bash
/root/sync-jobs.sh status
```

**Output:**
- Local file info (size, lines, last updated)
- Template file info
- Backup count
- Git repository status

### Pull Template Updates

**When to use:** Template structure improved in Git, you want those improvements locally

```bash
# 1. Backup your local file first
/root/sync-jobs.sh backup

# 2. Pull template updates
/root/sync-jobs.sh pull

# 3. Manually merge structure updates
# Compare files and apply changes you want
diff -y /root/policies-repo/AI_JOBS_TEMPLATE.md /root/AI_JOBS.md | less
```

**Note:** Automated merging not implemented to prevent data loss. Manual review required.

### Push Structure to Template

**When to use:** You improved the local structure and want to share it via Git

```bash
# 1. Push structure (automatically sanitizes VPS-specific data)
/root/sync-jobs.sh push

# 2. Review sanitized template
cat /root/policies-repo/AI_JOBS_TEMPLATE.md

# 3. Commit to git
cd /root/policies-repo
git add AI_JOBS_TEMPLATE.md
git commit -m "docs: update AI_JOBS_TEMPLATE structure"
git push
```

**What gets sanitized:**
- Domain names → `example.com`
- Specific paths → `/path/to/service`
- VPS-specific details → Generic placeholders
- Task completion data → Template examples

**What gets kept:**
- Document structure
- Section organization
- Instructions for AI agents
- Task format and examples

### Create Manual Backup
```bash
/root/sync-jobs.sh backup
```

**Backups stored in:** `/root/.job-backups/AI_JOBS_YYYYMMDD_HHMMSS.md`
**Retention:** Last 10 backups kept automatically

### Restore from Backup
```bash
/root/sync-jobs.sh restore
```

**Interactive:** Prompts you to confirm restoration of latest backup

### Compare Files
```bash
/root/sync-jobs.sh diff
```

**Shows:** Differences between local and template (first 50 lines)

---

## 🔐 Best Practices

### Daily Operations

1. **AI Agents Update Local File**
   ```bash
   # AI agents edit /root/AI_JOBS.md directly
   nano /root/AI_JOBS.md
   ```

2. **Never Commit Local File to Git**
   ```bash
   # /root/AI_JOBS.md stays OUT of git
   # It contains VPS-specific data
   ```

3. **Backup Before Major Changes**
   ```bash
   /root/sync-jobs.sh backup
   # Then make your changes
   ```

### Weekly/Monthly

1. **Pull Template Updates**
   ```bash
   cd /root/policies-repo
   git pull
   /root/sync-jobs.sh status  # Check if template changed
   ```

2. **Share Structure Improvements**
   ```bash
   # If you improved the structure locally
   /root/sync-jobs.sh push
   cd /root/policies-repo
   git add AI_JOBS_TEMPLATE.md
   git commit -m "docs: improve task template structure"
   git push
   ```

### Multi-Server Setup

**Server A (Development VPS):**
```bash
# Make structure improvements
nano /root/AI_JOBS.md
# Improve task organization, add sections, etc.

# Push to template
/root/sync-jobs.sh push
cd /root/policies-repo
git push
```

**Server B (Production VPS):**
```bash
# Pull updates
cd /root/policies-repo
git pull

# Review template changes
cat AI_JOBS_TEMPLATE.md

# Manually apply improvements to local file
# (while keeping production-specific data)
nano /root/AI_JOBS.md
```

---

## 🛡️ Safety Features

### Automatic Backups
- Created before pull/push operations
- Stored in `/root/.job-backups/`
- Last 10 backups retained
- Easy restoration with `restore` command

### Manual Merge Required
- No automatic merging (prevents data loss)
- You review and apply changes
- Full control over what gets updated

### Data Sanitization
- VPS-specific data removed when pushing
- Domains replaced with placeholders
- Paths replaced with generic examples
- Private information protected

### Git Safety
- Template in git, local file outside git
- No risk of committing sensitive data
- Clean separation of concerns

---

## 📊 Workflow Examples

### Example 1: New VPS Server Setup

```bash
# Day 1: Setup new VPS
cd /root
git clone https://github.com/Coriatel/Policies-Instructions-and-Skills-.git policies-repo
cp policies-repo/scripts/sync-jobs.sh .
chmod +x sync-jobs.sh

# Create local job list from template
./sync-jobs.sh pull

# Customize for this VPS
nano AI_JOBS.md
# - Add your domains
# - Add your services
# - Add your specific tasks
```

### Example 2: Template Update Available

```bash
# Week 5: Template improved on another server
cd /root/policies-repo
git pull  # New template structure available

./sync-jobs.sh status  # Check what changed
./sync-jobs.sh diff    # See differences

# Backup current local file
./sync-jobs.sh backup

# Review template improvements
cat AI_JOBS_TEMPLATE.md

# Manually apply improvements you want
nano /root/AI_JOBS.md
```

### Example 3: Share Your Improvements

```bash
# Month 3: You improved the task structure locally

# Push improvements to template
./sync-jobs.sh push

# Review sanitized output
cat /root/policies-repo/AI_JOBS_TEMPLATE.md

# Commit to git
cd /root/policies-repo
git add AI_JOBS_TEMPLATE.md
git commit -m "docs: add Phase 4 optimization tasks to template"
git push

# Now other servers can pull your improvements!
```

---

## 🔧 Troubleshooting

### Local file accidentally deleted
```bash
# Restore from backup
/root/sync-jobs.sh restore

# Or recreate from template
/root/sync-jobs.sh pull
```

### Template updates conflict with local changes
```bash
# Backup local first
/root/sync-jobs.sh backup

# Create side-by-side comparison
diff -y /root/policies-repo/AI_JOBS_TEMPLATE.md /root/AI_JOBS.md > /tmp/comparison.txt
less /tmp/comparison.txt

# Manually merge changes you want
nano /root/AI_JOBS.md
```

### Sync script not working
```bash
# Ensure script is executable
chmod +x /root/sync-jobs.sh

# Check file locations
ls -la /root/AI_JOBS.md
ls -la /root/policies-repo/AI_JOBS_TEMPLATE.md

# Run status check
/root/sync-jobs.sh status
```

### Need to revert push to template
```bash
cd /root/policies-repo
git log AI_JOBS_TEMPLATE.md  # Find previous version
git checkout <commit-hash> AI_JOBS_TEMPLATE.md
git commit -m "revert: restore previous template version"
git push
```

---

## 📚 Related Documentation

- **Main Job Tracker:** `/root/AI_JOBS.md` (your local file)
- **Template:** `/root/policies-repo/AI_JOBS_TEMPLATE.md`
- **VPS Environment Report:** `/root/VPS_ENVIRONMENT_REPORT.md`
- **Policies Repository:** https://github.com/Coriatel/Policies-Instructions-and-Skills-.git

---

## 🎯 Summary

**Local File** → Your working document with real tasks and data
**Template** → Shared structure in Git for all servers
**Sync Script** → Safely moves improvements between them

**Golden Rule:** Local file is the source of truth for YOUR VPS. Template is for STRUCTURE sharing.

---

**Version:** 1.0
**Last Updated:** 2026-01-14
**Maintained by:** AI Agents (Claude, Gemini, Codex)
