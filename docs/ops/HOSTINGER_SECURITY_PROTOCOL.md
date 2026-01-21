# Hostinger VPS Security Protocol - Complete Configuration

## Purpose

This document provides a **complete, actionable security protocol** for Hostinger VPS instances, including all required firewall ports, security settings, Google Antigravity access configuration, and step-by-step implementation instructions.

**Target**: Ubuntu-based Hostinger VPS (20.04/22.04/24.04 LTS)
**Last Updated**: 2026-01

---

## Table of Contents

1. [Required Firewall Ports](#required-firewall-ports)
2. [UFW Configuration](#ufw-configuration)
3. [Google Antigravity Access](#google-antigravity-access)
4. [SSL/TLS Configuration](#ssltls-configuration)
5. [Fail2Ban Setup](#fail2ban-setup)
6. [Security Software Stack](#security-software-stack)
7. [Application-Specific Ports](#application-specific-ports)
8. [Cloudflare Integration](#cloudflare-integration)
9. [Quick Setup Script](#quick-setup-script)
10. [Verification Checklist](#verification-checklist)

---

## Required Firewall Ports

### Core Services (Always Open)

| Port | Protocol | Service | Notes |
|------|----------|---------|-------|
| 22 | TCP | SSH | Remote management (consider changing to non-standard) |
| 80 | TCP | HTTP | Web traffic (redirects to HTTPS) |
| 443 | TCP | HTTPS | Secure web traffic |

### Application Ports (As Needed)

| Port | Protocol | Service | Notes |
|------|----------|---------|-------|
| 3000 | TCP | Node.js Dev | Development server |
| 4000 | TCP | API Server | Backend API (Flow-Control) |
| 5432 | TCP | PostgreSQL | **Only from localhost by default** |
| 5678 | TCP | n8n Workflow | If using n8n automation |
| 8080 | TCP | Alternative HTTP | Proxy/development |
| 3306 | TCP | MySQL/MariaDB | **Only from localhost by default** |

### Google Antigravity / AI Agent Access

| Port | Protocol | Service | Notes |
|------|----------|---------|-------|
| 443 | TCP | HTTPS | Required for API calls |
| 80 | TCP | HTTP | Fallback |

**Required Outbound Access** (for AI agents and tools):
- `*.googleapis.com` - Google APIs
- `*.google.com` - Google services
- `api.anthropic.com` - Claude API
- `*.openai.com` - OpenAI API (if used)
- `github.com` - Repository access
- `registry.npmjs.org` - NPM packages
- `pypi.org` - Python packages

---

## UFW Configuration

### Complete Setup Commands

```bash
# Install UFW (if not installed)
sudo apt update && sudo apt install ufw -y

# Reset to default (clean slate)
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Core services
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Application services (uncomment as needed)
sudo ufw allow 4000/tcp comment 'API Server'
# sudo ufw allow 3000/tcp comment 'Node.js Dev'
# sudo ufw allow 5678/tcp comment 'n8n Workflow'
# sudo ufw allow 8080/tcp comment 'Alternative HTTP'

# Enable firewall
sudo ufw enable

# Verify status
sudo ufw status verbose
```

### Expected Output

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                   # SSH
80/tcp                     ALLOW IN    Anywhere                   # HTTP
443/tcp                    ALLOW IN    Anywhere                   # HTTPS
4000/tcp                   ALLOW IN    Anywhere                   # API Server
```

### Restricting Access by IP (Enhanced Security)

```bash
# Allow SSH only from specific IPs
sudo ufw delete allow 22/tcp
sudo ufw allow from YOUR_HOME_IP to any port 22 proto tcp comment 'SSH from home'
sudo ufw allow from OFFICE_IP to any port 22 proto tcp comment 'SSH from office'

# Allow API access from Cloudflare IPs only
# See Cloudflare IP ranges: https://www.cloudflare.com/ips/
```

---

## Google Antigravity Access

### Browser Allowlist Configuration

For safe browsing with AI agents, configure `~/.gemini/antigravity/browserAllowlist.txt`:

```
# Google Services
antigravity.google
developers.google.com
cloud.google.com
console.cloud.google.com

# Development Resources
github.com
docs.github.com
stackoverflow.com
npmjs.com
pypi.org

# Hosting & Infrastructure
support.hostinger.com
hostinger.com
cloudflare.com
dash.cloudflare.com

# Documentation
nodejs.org
prisma.io
expressjs.com
reactjs.org

# AI Services
claude.ai
platform.openai.com
```

### MCP Server Configuration

For Claude Code / Antigravity MCP integration:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"
      }
    }
  }
}
```

**Security Note**: Store tokens in environment variables, never in config files committed to Git.

---

## SSL/TLS Configuration

### Let's Encrypt with Certbot

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Verify auto-renewal
sudo certbot renew --dry-run

# Check certificate status
sudo certbot certificates
```

### Nginx SSL Settings (Modern Configuration)

Add to nginx config (`/etc/nginx/snippets/ssl-params.conf`):

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
add_header Strict-Transport-Security "max-age=63072000" always;
```

---

## Fail2Ban Setup

### Installation and Configuration

```bash
# Install
sudo apt install fail2ban -y

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit configuration
sudo nano /etc/fail2ban/jail.local
```

### Recommended jail.local Configuration

```ini
[DEFAULT]
# Ban for 1 hour
bantime = 3600
# Time window for counting failures
findtime = 600
# Max attempts before ban
maxretry = 3
# Email notifications (optional)
# destemail = your@email.com
# sendername = Fail2Ban
# action = %(action_mwl)s

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400

[nginx-http-auth]
enabled = true
port = http,https
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3

[nginx-botsearch]
enabled = true
port = http,https
filter = nginx-botsearch
logpath = /var/log/nginx/access.log
maxretry = 2

[nginx-limit-req]
enabled = true
port = http,https
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
maxretry = 10
```

### Start and Enable

```bash
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Verify status
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

---

## Security Software Stack

### Required Packages

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Security essentials
sudo apt install -y \
  ufw \
  fail2ban \
  unattended-upgrades \
  logwatch \
  rkhunter

# Malware scanning
sudo apt install -y clamav clamav-daemon
sudo freshclam

# Monitoring tools
sudo apt install -y htop iotop nethogs

# Optional: Intrusion detection
sudo apt install -y aide
sudo aideinit
```

### Enable Automatic Security Updates

```bash
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Verify
sudo systemctl status unattended-upgrades
```

### Monthly Scheduled Updates (Backup + Upgrade)

This VPS also uses a monthly security update script that performs a full backup before running updates.

```bash
# Script + schedule
sudo ls -la /usr/local/bin/monthly-security-update.sh
sudo cat /etc/cron.d/monthly-security-update

# Log
sudo tail -n 200 /var/log/monthly-update.log
```

---

## Application-Specific Ports

### Flow-Control Application

| Service | Port | Access |
|---------|------|--------|
| API Server | 4000 | Public (via Cloudflare) |
| PostgreSQL | 5432 | Localhost only |
| Frontend (if hosted) | 80/443 | Public |

### Configuration

```bash
# API Server
sudo ufw allow 4000/tcp comment 'Flow-Control API'

# PostgreSQL - bind to localhost only
# Edit /etc/postgresql/*/main/postgresql.conf
listen_addresses = 'localhost'
```

### n8n Workflow (If Used)

```bash
sudo ufw allow 5678/tcp comment 'n8n Workflow'
```

---

## Cloudflare Integration

### Required Settings

**SSL/TLS**:
- Mode: **Full (Strict)**
- Minimum TLS Version: **1.2**
- Automatic HTTPS Rewrites: **On**

**Security**:
- Security Level: **Medium** or **High**
- Bot Fight Mode: **On**
- Browser Integrity Check: **On**

### Restrict Origin to Cloudflare Only

```bash
# Get Cloudflare IP ranges
curl -s https://www.cloudflare.com/ips-v4 > /tmp/cf-ips.txt
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf-ips.txt

# Allow only Cloudflare IPs to access web ports
# (Advanced - implement after testing)
```

### Nginx Real IP Configuration

```nginx
# /etc/nginx/conf.d/cloudflare.conf
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 131.0.72.0/22;
real_ip_header CF-Connecting-IP;
```

---

## Quick Setup Script

Save as `~/security-setup.sh`:

```bash
#!/bin/bash
# Hostinger VPS Security Setup Script
# Run with: sudo bash security-setup.sh

set -e

echo "=== Hostinger VPS Security Setup ==="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Update system
echo -e "${YELLOW}[1/7] Updating system...${NC}"
apt update && apt upgrade -y

# Install security packages
echo -e "${YELLOW}[2/7] Installing security packages...${NC}"
apt install -y ufw fail2ban unattended-upgrades clamav clamav-daemon

# Configure UFW
echo -e "${YELLOW}[3/7] Configuring firewall...${NC}"
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 4000/tcp comment 'API Server'
ufw --force enable

# Configure Fail2Ban
echo -e "${YELLOW}[4/7] Configuring Fail2Ban...${NC}"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
cat >> /etc/fail2ban/jail.local << 'EOF'

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF
systemctl restart fail2ban
systemctl enable fail2ban

# Enable automatic updates
echo -e "${YELLOW}[5/7] Enabling automatic updates...${NC}"
dpkg-reconfigure --priority=low unattended-upgrades

# Update ClamAV
echo -e "${YELLOW}[6/7] Updating virus definitions...${NC}"
freshclam || true

# Create security audit script
echo -e "${YELLOW}[7/7] Creating audit script...${NC}"
cat > /usr/local/bin/security-audit.sh << 'AUDIT'
#!/bin/bash
echo "=== VPS Security Audit ==="
echo ""
echo "[1] Firewall Status:"
ufw status | head -10
echo ""
echo "[2] Fail2Ban Status:"
fail2ban-client status sshd 2>/dev/null | grep -E "Currently banned|Total banned" || echo "Not configured"
echo ""
echo "[3] Failed SSH (last 24h):"
grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %d)" | wc -l
echo ""
echo "[4] Disk Space:"
df -h / | tail -1
echo ""
echo "[5] Memory:"
free -h | grep Mem
echo ""
echo "=== Audit Complete ==="
AUDIT
chmod +x /usr/local/bin/security-audit.sh

echo ""
echo -e "${GREEN}=== Security Setup Complete ===${NC}"
echo ""
echo "Run 'security-audit.sh' to verify configuration"
echo ""
ufw status verbose
```

---

## Verification Checklist

### After Setup, Verify:

- [ ] **UFW Active**: `sudo ufw status verbose`
- [ ] **Fail2Ban Running**: `sudo systemctl status fail2ban`
- [ ] **SSH Working**: Test from another terminal before closing
- [ ] **HTTP/HTTPS Accessible**: `curl -I http://YOUR_IP`
- [ ] **API Port Open**: `curl http://YOUR_IP:4000/api/health`
- [ ] **PostgreSQL Localhost Only**: `sudo ss -tulpn | grep 5432`
- [ ] **SSL Certificate Valid**: `sudo certbot certificates`
- [ ] **Auto-updates Enabled**: `sudo systemctl status unattended-upgrades`

### Security Audit Command

```bash
sudo /usr/local/bin/security-audit.sh
```

---

## Troubleshooting

### Cannot Connect After Firewall Change

1. Access VPS via Hostinger VNC Console (hPanel)
2. Check UFW status: `sudo ufw status`
3. If locked out: `sudo ufw allow 22/tcp && sudo ufw reload`

### Fail2Ban Not Banning

```bash
# Check jail status
sudo fail2ban-client status sshd

# Check log path
sudo ls -la /var/log/auth.log

# Restart fail2ban
sudo systemctl restart fail2ban
```

### API Not Accessible

```bash
# Check if service running
pm2 status

# Check port listening
sudo ss -tulpn | grep 4000

# Check firewall
sudo ufw status | grep 4000

# Check logs
pm2 logs flow-control-api
```

---

## Related Documentation

- [Security Baseline for Ubuntu](/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md)
- [VPS Operations Runbook](/docs/ops/HOSTINGER_VPS_RUNBOOK.md)
- [AI Agent Safety Protocol](/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md)
- [Terminal & SSH Policy](/docs/ops/TERMINAL_SSH_POLICY.md)
- [Malware Response](/docs/ops/HOSTINGER_MALWARE_RESPONSE.md)
- [Google Antigravity Setup](/antigravity-google/README.md)

---

**Last Updated**: 2026-01
**Maintainer**: DevOps Team
