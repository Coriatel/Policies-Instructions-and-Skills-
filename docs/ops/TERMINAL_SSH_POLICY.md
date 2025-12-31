# Terminal & SSH Policy — Safe Automation

## Purpose

This document defines safe operating procedures for terminal commands, SSH operations, and VPS management when working autonomously or with AI assistants.

## Core Principles

### 1. Confirmation Gates
**Always ask for confirmation before**:
- Deleting data (`rm -rf`, `DROP DATABASE`, etc.)
- Force operations (`git push --force`, `docker system prune`)
- Modifying production systems
- Operations involving secrets/credentials
- Irreversible actions

### 2. Never Echo Secrets
```bash
# ❌ DON'T
echo "API_KEY=sk_live_abc123"
cat .env
echo $DATABASE_PASSWORD

# ✅ DO
# Keep secrets in files, never print them
```

### 3. Logging Without Secrets
```bash
# ❌ DON'T log commands with secrets
echo "Running: mysql -u admin -p'secretpass' ..."

# ✅ DO redact sensitive data
echo "Running: mysql -u admin -p'[REDACTED]' ..."
```

## Allowed Commands (No Confirmation Needed)

### Safe Read Operations
```bash
ls, ls -la
cat <file>
head, tail
pwd
whoami
df -h
free -m
ps aux
top, htop
git status, git log, git diff
npm list, npm outdated
docker ps, docker images
systemctl status <service>
```

### Safe Write Operations
```bash
mkdir <dir>
touch <file>
cp <file> <backup>  # creating backups
git add, git commit
npm install <package>
```

## Prohibited Without Confirmation

### Destructive Operations
```bash
rm -rf
rm -r
DROP DATABASE
DROP TABLE
TRUNCATE
docker system prune
docker volume prune
git push --force
git reset --hard
```

### Production Operations
```bash
systemctl stop <production-service>
systemctl restart <production-service>
pm2 delete
pm2 restart <production-app>
```

### Bulk Operations
```bash
find . -name "*.js" -delete
git clean -fd
npm uninstall <multiple packages>
```

## SSH Usage Guidelines

### Connection
```bash
# ✅ DO: Use SSH keys (not passwords when possible)
ssh -i ~/.ssh/id_rsa user@host

# ✅ DO: Verify host fingerprint on first connection
# (System will prompt - user should confirm)

# ❌ DON'T: Accept unknown hosts blindly in scripts
# StrictHostKeyChecking=no  # Avoid in production
```

### File Transfer
```bash
# ✅ DO: Use scp or rsync for file transfer
scp file.txt user@host:/path/to/destination
rsync -avz local/ user@host:/remote/

# ✅ DO: Verify paths before transfer
ls -la /path/to/source
ssh user@host "ls -la /path/to/destination"
```

### Remote Commands
```bash
# ✅ DO: Use quotes for remote commands
ssh user@host "systemctl status nginx"

# ✅ DO: Check before executing destructive commands
ssh user@host "ls -la /path/to/delete"  # Verify first
# Then ask for confirmation before:
ssh user@host "rm -rf /path/to/delete"
```

## Environment Variables

### Loading Secrets
```bash
# ✅ DO: Load from .env file
source .env
# or
export $(cat .env | xargs)

# ✅ DO: Verify variables are set (without printing)
if [ -z "$API_KEY" ]; then
  echo "ERROR: API_KEY not set"
  exit 1
fi

# ❌ DON'T: Print environment variables
env | grep API  # NO! May expose secrets
```

### Passing to Commands
```bash
# ✅ DO: Use environment variables
DATABASE_URL=$DATABASE_URL npm run migrate

# ❌ DON'T: Hardcode
DATABASE_URL="postgresql://user:pass@host/db" npm run migrate
```

## Git Operations

### Safe Operations
```bash
git clone <repo>
git pull
git fetch
git status
git log
git diff
git add <files>
git commit -m "message"
git push  # to feature branch
```

### Requires Confirmation
```bash
git push --force
git push -f
git reset --hard
git clean -fd
git push origin --delete <branch>
```

### Secrets in Git
```bash
# ✅ DO: Check .gitignore before committing
cat .gitignore | grep .env

# ✅ DO: Verify no secrets before pushing
git diff --cached  # Review staged changes

# ❌ DON'T: Commit .env files
git add .env  # NO!
```

## Package Management

### Installing Dependencies
```bash
# ✅ DO: Install from package.json
npm install
npm ci  # Clean install (preferred in CI)

# ✅ DO: Install specific package
npm install express

# ⚠️ CAUTION: Global installs (may require sudo)
npm install -g <package>  # Ask before global install
```

### Updating Dependencies
```bash
# ✅ DO: Check outdated packages first
npm outdated

# ⚠️ CAUTION: Major updates
npm update  # Ask before updating all
npm install <package>@latest  # Ask for major versions
```

## Docker Operations

### Safe Operations
```bash
docker ps
docker images
docker logs <container>
docker inspect <container>
docker-compose up -d  # Start services
docker-compose logs
```

### Requires Confirmation
```bash
docker stop <container>
docker rm <container>
docker rmi <image>
docker system prune  # Deletes unused data
docker volume prune  # Deletes unused volumes
docker-compose down  # Stops and removes containers
docker-compose down -v  # Also removes volumes
```

## Database Operations

### Safe Operations
```bash
# View schema
psql -d dbname -c "\dt"
psql -d dbname -c "SELECT * FROM users LIMIT 10;"

# Backups
pg_dump dbname > backup.sql
mysqldump dbname > backup.sql
```

### Requires Confirmation
```bash
# Destructive operations
DROP DATABASE
DROP TABLE
TRUNCATE TABLE
DELETE FROM users;  # Without WHERE clause!

# Restore (overwrites data)
psql -d dbname < backup.sql

# Migrations (schema changes)
npx prisma migrate deploy  # In production
```

## Logging Policy

### What to Log
```bash
# ✅ DO: Log command execution (redacted)
echo "Executing: npm install"
echo "Connecting to: user@example.com (SSH)"
echo "Running migration: 20240115_add_users_table"
```

### What NOT to Log
```bash
# ❌ DON'T: Log passwords, tokens, keys
echo "Password: $DB_PASSWORD"  # NO!
echo "API Key: $API_KEY"  # NO!
echo "JWT Token: $TOKEN"  # NO!
```

### Redaction
```bash
# ✅ DO: Redact sensitive parts
CMD="mysql -u admin -p'${DB_PASSWORD}'"
echo "Running: mysql -u admin -p'[REDACTED]'"
```

## Checklist Before Execution

### For Any Command
- [ ] Is this command reversible?
- [ ] Does it modify production?
- [ ] Does it involve secrets?
- [ ] Have I verified paths/names?
- [ ] Is there a backup if needed?

### For SSH Operations
- [ ] Correct host?
- [ ] Correct user?
- [ ] Verified path on remote?
- [ ] Tested with dry-run if available?

### For Database Operations
- [ ] Backup created?
- [ ] Tested on dev/staging first?
- [ ] WHERE clause included (for UPDATE/DELETE)?
- [ ] LIMIT clause included (for testing)?

## Emergency Procedures

### If Secrets Are Exposed
1. **Immediately revoke** the exposed credential
2. **Generate new** secret/key
3. **Update** .env files and services
4. **Audit** logs for unauthorized access
5. **Document** the incident

### If Data Is Accidentally Deleted
1. **Stop** all operations immediately
2. **Assess** scope of deletion
3. **Restore** from most recent backup
4. **Verify** restored data integrity
5. **Document** for post-mortem

## Best Practices Summary

### ✅ DO
- Verify before executing
- Use backups before destructive operations
- Keep secrets in .env files
- Use SSH keys instead of passwords
- Test on dev/staging first
- Log operations (without secrets)
- Ask for confirmation when unsure

### ❌ DON'T
- Echo secrets to console
- Skip confirmation for destructive operations
- Commit secrets to git
- Use `rm -rf` without verification
- Force push to main/master
- Run production commands without testing
- Trust user input blindly

---

**Related**:
- [Security & Secrets Rule](../../.cursor/rules/100-security-secrets.md)
- [Terminal/SSH Skill](/skills/terminal-ssh-vps/skill.md)
- [Git Workflow Rule](../../.cursor/rules/090-git-workflow.md)

**Last Updated**: 2025-12-31
