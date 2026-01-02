# Prompts Library

## Purpose

This library provides copy-paste ready prompts for common development and operations tasks. These prompts are designed to work with AI assistants (Claude Code, Cursor, ChatGPT, etc.) while ensuring compliance with security policies and best practices.

---

## Table of Contents

1. [Hostinger VPS Operations](#hostinger-vps-operations)
2. [WordPress Development](#wordpress-development)
3. [General Development](#general-development)
4. [Security & Compliance](#security--compliance)

---

## Hostinger VPS Operations

### Prompt: Secure Baseline Hardening (Agent-Driven)

**Use case**: Initial hardening of a fresh Hostinger VPS with AI assistance.

```
I need you to harden a fresh Hostinger VPS (Ubuntu 22.04) following defensive security best practices.

OPERATING MODE: Work autonomously with confirmation gates for destructive operations.

CONTEXT:
- VPS IP: [YOUR_VPS_IP]
- SSH access: root@[IP] (will create non-root admin user)
- Purpose: WordPress hosting
- Provider: Hostinger (strict ToS compliance required)

CRITICAL CONSTRAINTS:
- Defensive security ONLY (no offensive tools)
- Follow Hostinger ToS strictly
- Ask before: destructive operations, credential changes, service restarts
- Document all assumptions

TASKS:
1. System updates and security patches
2. Create non-root admin user with sudo access
3. Set up SSH key-based authentication (I'll provide public key)
4. Harden SSH config (disable password auth, disable root login)
5. Configure UFW firewall (allow 22, 80, 443)
6. Install and configure fail2ban (SSH protection)
7. Secure shared memory
8. Install ClamAV for malware scanning
9. Set up automatic security updates
10. Create security audit script

REFERENCES:
- Follow: /docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md
- Skill: /skills/hostinger-vps-ops/skill.md
- AI Safety: /docs/ops/HOSTINGER_AI_AGENT_SAFETY.md

Proceed with the hardening process. Ask for confirmation before any irreversible changes.
```

---

### Prompt: Malware Flag Triage & Cleanup Plan (Defensive)

**Use case**: Responding to Hostinger malware detection notice.

```
Hostinger has flagged my VPS for malware. I need your help to investigate and remediate.

OPERATING MODE: Incident Response Mode (elevated permissions with documentation)

CONTEXT:
- VPS IP: [YOUR_VPS_IP]
- Hostinger Ticket: #[TICKET_NUMBER]
- Flagged Date: [DATE]
- Flagged Files: [IF PROVIDED BY HOSTINGER]
- Application: WordPress site at /var/www/html

CRITICAL REQUIREMENTS:
- Preserve evidence FIRST (snapshot, logs)
- Document EVERYTHING with timestamps
- Defensive remediation only
- Communicate progress to Hostinger support
- Prevent reinfection

INCIDENT RESPONSE WORKFLOW:
1. IMMEDIATE (First 2 hours):
   - Acknowledge Hostinger notice (I'll send, you draft)
   - Create VPS snapshot via Hostinger panel (I'll do manually)
   - Collect and preserve logs
   - Identify malware location
   - Assess scope

2. INVESTIGATION (2-8 hours):
   - Determine entry vector (plugin vuln, weak password, file upload)
   - Check for additional backdoors
   - Assess damage scope
   - Check for data exfiltration

3. REMEDIATION (8-24 hours):
   - Remove malware files (after verification)
   - Patch vulnerability
   - Rotate ALL credentials (DB, WordPress, SSH)
   - Harden security (block PHP in uploads, etc.)
   - Verify clean with ClamAV

4. POST-INCIDENT (24-72 hours):
   - Monitor for reinfection
   - Create incident report
   - Communicate detailed report to Hostinger
   - Request rescan

REFERENCE PROCEDURE:
- Follow: /docs/ops/HOSTINGER_MALWARE_RESPONSE.md

Begin with Step 1 (IMMEDIATE). Ask before deleting any files.
```

---

### Prompt: WordPress Secure Deployment (Cloudflare + Minimal Plugins)

**Use case**: Deploy hardened WordPress on Hostinger VPS with Cloudflare.

```
Deploy a secure WordPress installation on Hostinger VPS with Cloudflare integration.

OPERATING MODE: Autonomous with confirmation gates for production changes.

CONTEXT:
- VPS: [IP_ADDRESS] (already hardened with baseline security)
- Domain: [YOURDOMAIN.COM]
- Cloudflare account: Ready (nameservers not yet changed)
- LEMP stack: Not yet installed

REQUIREMENTS:
1. Secure WordPress installation (minimal attack surface)
2. Cloudflare WAF integration
3. SSL/TLS (Let's Encrypt + Cloudflare origin cert)
4. Minimal plugin philosophy (< 10 plugins)
5. Auto-updates enabled
6. Daily backups configured

DEPLOYMENT STEPS:

Phase 1: LEMP Stack
- Install Nginx, MariaDB, PHP 8.1
- Secure MySQL (mysql_secure_installation)
- Bind MySQL to localhost only
- Create WordPress database with strong password

Phase 2: WordPress Installation
- Download from official source (wordpress.org)
- Set correct ownership (www-data:www-data)
- Set permissions (755/644)
- Create wp-config.php with security keys
- Change table prefix (security)
- Disable file editing (DISALLOW_FILE_EDIT)

Phase 3: Nginx Hardening
- Block PHP execution in uploads
- Disable XML-RPC
- Protect wp-config.php
- Security headers (X-Frame-Options, CSP, etc.)
- Rate limiting for wp-login.php
- Hide Nginx version

Phase 4: Essential Plugins Only
- Wordfence Security (or Sucuri)
- UpdraftPlus (backups)
- Limit Login Attempts Reloaded
- Two-Factor (2FA)
- Yoast SEO (if needed)
- Total: < 10 plugins

Phase 5: Cloudflare Integration
- Add site to Cloudflare (I'll do via dashboard)
- Configure DNS (I'll update nameservers)
- SSL/TLS mode: Full (strict)
- Install origin certificate on VPS
- Security level: Medium/High
- Firewall rules (protect wp-admin, rate limiting)

Phase 6: Backups & Monitoring
- Daily database backups (cron)
- Weekly file backups (cron)
- Offsite backup sync (I'll configure cloud storage)
- Weekly malware scans (ClamAV)
- Monitoring setup (I'll configure external uptime monitor)

REFERENCES:
- Follow: /docs/ops/HOSTINGER_WORDPRESS_HARDENING.md
- Runbook: /docs/ops/HOSTINGER_VPS_RUNBOOK.md

Proceed with Phase 1. Ask before installing any software or making configuration changes.
```

---

### Prompt: Ongoing Maintenance Weekly Checklist

**Use case**: Weekly maintenance routine for Hostinger VPS.

```
Perform weekly maintenance on Hostinger VPS running WordPress.

OPERATING MODE: Autonomous for read operations, confirm before writes.

VPS: [IP_ADDRESS]
WordPress path: /var/www/html

WEEKLY CHECKLIST:

1. System Health Check
   - [ ] Check disk space (alert if >80%)
   - [ ] Check memory usage
   - [ ] Review failed SSH attempts (auth.log)
   - [ ] Check fail2ban banned IPs
   - [ ] Verify Nginx status
   - [ ] Verify MySQL status

2. WordPress Updates
   - [ ] Check for core updates
   - [ ] Check for plugin updates
   - [ ] Check for theme updates
   - [ ] Review plugin list (flag unused plugins)
   - [ ] Verify auto-updates are enabled

3. Security Review
   - [ ] Review auth.log for anomalies
   - [ ] Check for suspicious files in uploads
   - [ ] Review Nginx access log (top IPs, top requests)
   - [ ] Verify SSL certificate expiry date
   - [ ] Check Wordfence scan results

4. Backup Verification
   - [ ] Verify database backup completed (check latest backup file)
   - [ ] Verify file backup completed (if weekly schedule)
   - [ ] Check backup size (sudden changes indicate issues)

5. Performance Check
   - [ ] Test website load time
   - [ ] Review Nginx error log
   - [ ] Check for slow queries (MySQL)
   - [ ] Review Cloudflare analytics

6. Compliance Check
   - [ ] No active Hostinger support tickets
   - [ ] No malware detected
   - [ ] No ToS violations

REPORT FORMAT:
Create summary report with:
- ✅ Items passing
- ⚠️  Items needing attention
- ❌ Items failing
- Recommended actions

Execute checklist and provide summary report.
```

---

## WordPress Development

### Prompt: Create Custom Post Type with RBAC

```
Create a custom post type "Projects" in WordPress with role-based access control.

REQUIREMENTS:
- Post type: projects
- Supports: title, editor, thumbnail, custom fields
- Taxonomies: project_category, project_tag
- RBAC:
  - Admin: full access
  - Editor: can create, edit, delete own projects
  - Author: can create, edit own projects (no delete)
  - Subscriber: view only

IMPLEMENTATION:
- Use proper WordPress hooks (init)
- Register post type with capabilities
- Map capabilities to roles
- Include admin column customization
- Add meta box for custom fields

Follow WordPress coding standards.
```

---

### Prompt: WooCommerce Custom Order Status

```
Add custom order status "Pending Payment Verification" to WooCommerce.

REQUIREMENTS:
- Status slug: wc-payment-verify
- Label: "Pending Payment Verification"
- Add to order status dropdown
- Trigger email notification when status applied
- Show in admin order reports
- Allow transition from "Pending Payment" status
- Prevent transition to "Completed" without verification

Include email template and admin styles.
```

---

## General Development

### Prompt: React Component with RTL Support

```
Create a React component for a product card with RTL (Hebrew) support.

REQUIREMENTS:
- Component: ProductCard
- Props: product object (name, price, image, description)
- Features:
  - Responsive design (mobile-first)
  - RTL/LTR automatic switching via CSS
  - Accessible (ARIA labels)
  - Price formatting (₪ for Hebrew, $ for English)
  - Add to cart button with loading state

STYLING:
- Use SCSS with BEM methodology
- Logical properties for RTL (margin-inline, padding-block)
- No hard-coded left/right properties
- Support both Hebrew (he) and English (en)

ACCESSIBILITY:
- Semantic HTML
- Keyboard navigation
- Screen reader support
- Focus indicators

Include TypeScript types and Storybook story.
```

---

### Prompt: Express API with Prisma & RBAC

```
Create Express API endpoint for user management with Prisma and RBAC.

REQUIREMENTS:

Endpoint: POST /api/users
- Create new user
- Input validation (email, password strength)
- Hash password with bcrypt
- Assign default role
- Return JWT token

Endpoint: GET /api/users/:id
- Get user by ID
- Require authentication
- RBAC: Admin can view any user, User can view own profile only

Endpoint: PUT /api/users/:id
- Update user
- RBAC: Admin can update any user, User can update own profile only
- Validate input
- Prevent role escalation

Endpoint: DELETE /api/users/:id
- Delete user
- RBAC: Admin only
- Soft delete (set deletedAt timestamp)

IMPLEMENTATION:
- Use Express Router
- Prisma for database operations
- JWT middleware for authentication
- RBAC middleware (checkRole)
- Error handling (try/catch)
- Input validation (Joi or Zod)
- Return appropriate HTTP status codes

Include Prisma schema for User model.
```

---

## Security & Compliance

### Prompt: Security Audit Checklist

```
Perform security audit on the codebase and provide checklist report.

AUDIT AREAS:

1. Secrets Management
   - [ ] No hardcoded credentials in code
   - [ ] .env file in .gitignore
   - [ ] No secrets in git history
   - [ ] Environment variables used for all sensitive config

2. Authentication & Authorization
   - [ ] Password hashing (bcrypt/argon2)
   - [ ] JWT tokens with expiration
   - [ ] Refresh token mechanism
   - [ ] RBAC implemented correctly
   - [ ] Session management secure

3. Input Validation
   - [ ] All user inputs validated
   - [ ] SQL injection prevention (parameterized queries)
   - [ ] XSS prevention (output encoding)
   - [ ] CSRF protection (tokens)
   - [ ] File upload validation (type, size)

4. API Security
   - [ ] Rate limiting implemented
   - [ ] CORS configured correctly
   - [ ] HTTPS enforced
   - [ ] API keys secured
   - [ ] Error messages don't leak sensitive info

5. Database Security
   - [ ] Least privilege database user
   - [ ] No direct SQL queries (use ORM)
   - [ ] Backup strategy in place
   - [ ] Database credentials in environment variables

6. Dependencies
   - [ ] All dependencies up to date
   - [ ] No known vulnerabilities (npm audit)
   - [ ] Minimal dependencies
   - [ ] Lock file committed (package-lock.json)

Provide detailed report with:
- ✅ Passing items
- ⚠️  Items needing improvement
- ❌ Critical issues
- Remediation steps for each failing item
```

---

### Prompt: GDPR Compliance Review

```
Review application for GDPR compliance and provide recommendations.

REVIEW AREAS:

1. Data Collection
   - What personal data is collected?
   - Is consent obtained before collection?
   - Is there a clear privacy policy?

2. Data Storage
   - Where is data stored?
   - Is data encrypted at rest?
   - How long is data retained?

3. Data Access
   - Can users access their data? (data portability)
   - Can users update their data?
   - Can users delete their data? (right to be forgotten)

4. Data Sharing
   - Is data shared with third parties?
   - Are data processing agreements in place?
   - Is consent obtained for sharing?

5. Security Measures
   - Is data encrypted in transit (HTTPS)?
   - Is data encrypted at rest?
   - Are access controls in place?
   - Is there audit logging?

6. Breach Notification
   - Is there a breach response plan?
   - Can breaches be detected?
   - Is there 72-hour notification process?

Provide:
- Compliance status for each area
- Gap analysis
- Recommended actions
- Implementation priority (high/medium/low)
```

---

## Usage Instructions

### How to Use These Prompts

1. **Copy the prompt** from this library
2. **Replace placeholders** in [BRACKETS] with your actual values
3. **Paste into AI assistant** (Claude Code, Cursor, ChatGPT)
4. **Provide context** if needed (share relevant files, configurations)
5. **Review AI suggestions** before executing

### Customizing Prompts

- Add project-specific requirements
- Adjust operating mode (autonomous vs confirm-each-step)
- Include reference to local documentation
- Specify tech stack versions

### Safety Notes

- Always review AI-generated code before execution
- Test in development environment first
- Backup before making production changes
- Follow confirmation gates for destructive operations

---

## Related Documentation

- [Hostinger VPS Runbook](/docs/ops/HOSTINGER_VPS_RUNBOOK.md)
- [AI Agent Safety Protocol](/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md)
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md)
- [Security Baseline](/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md)

---

**Contributing**: To add new prompts, follow the template in `docs/CONTRIBUTING.md`

**Last Updated**: 2025-12-31
