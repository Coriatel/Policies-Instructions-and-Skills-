# Hostinger WordPress Hardening Guide

## Purpose

This guide provides comprehensive security hardening procedures for WordPress installations on Hostinger VPS, aligned with provider compliance requirements and defensive security best practices.

**Target**: WordPress 6.x on Ubuntu VPS with Nginx/MariaDB/PHP (LEMP stack)

---

## Table of Contents

1. [Pre-Deployment Security](#pre-deployment-security)
2. [Installation Security](#installation-security)
3. [File System Hardening](#file-system-hardening)
4. [WordPress Configuration Hardening](#wordpress-configuration-hardening)
5. [Database Security](#database-security)
6. [Nginx Security Configuration](#nginx-security-configuration)
7. [Plugin & Theme Management](#plugin--theme-management)
8. [User Account Security](#user-account-security)
9. [Cloudflare Integration](#cloudflare-integration)
10. [Ongoing Maintenance](#ongoing-maintenance)

---

## Pre-Deployment Security

**Complete these BEFORE installing WordPress**:

### 1. LEMP Stack Installation

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install MariaDB
sudo apt install mariadb-server mariadb-client -y

# Install PHP and required extensions
sudo apt install php8.1-fpm php8.1-mysql php8.1-curl php8.1-gd php8.1-intl \
  php8.1-mbstring php8.1-soap php8.1-xml php8.1-xmlrpc php8.1-zip -y

# Verify installations
sudo systemctl status nginx
sudo systemctl status mysql
sudo systemctl status php8.1-fpm
```

---

### 2. Secure MySQL/MariaDB

```bash
# Run security script
sudo mysql_secure_installation
```

**Answer prompts**:
- Switch to unix_socket authentication: **N** (we'll create specific user)
- Change root password: **Y** (set strong password)
- Remove anonymous users: **Y**
- Disallow root login remotely: **Y**
- Remove test database: **Y**
- Reload privilege tables: **Y**

**Bind to localhost only**:
```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

**Set**:
```
bind-address = 127.0.0.1
```

**Restart MySQL**:
```bash
sudo systemctl restart mysql
```

**Verify**:
```bash
sudo netstat -tulpn | grep mysql
# Should show: 127.0.0.1:3306 (NOT 0.0.0.0:3306)
```

---

### 3. Create WordPress Database

```bash
# Login to MySQL
sudo mysql -u root -p
```

**Execute SQL** (replace values):
```sql
-- Create database with UTF8MB4 charset
CREATE DATABASE wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user with strong password (generate with: openssl rand -base64 32)
CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD_HERE';

-- Grant privileges
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Exit
EXIT;
```

**Test database access**:
```bash
mysql -u wordpress_user -p wordpress_db
# Enter password, should connect successfully
```

---

## Installation Security

### 1. Download WordPress from Official Source

**⚠️ NEVER use WordPress from unknown sources, nulled themes, or pirated plugins.**

```bash
# Create web root
sudo mkdir -p /var/www/html

# Download latest WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz

# Verify download (optional but recommended)
wget https://wordpress.org/latest.tar.gz.sha256
sha256sum -c latest.tar.gz.sha256
# Should show: latest.tar.gz: OK

# Extract to web root
sudo tar -xzf latest.tar.gz -C /var/www/html --strip-components=1

# Clean up
rm latest.tar.gz latest.tar.gz.sha256
```

---

### 2. Set Correct Ownership and Permissions

```bash
# Set ownership to www-data (Nginx user)
sudo chown -R www-data:www-data /var/www/html

# Set directory permissions to 755
sudo find /var/www/html -type d -exec chmod 755 {} \;

# Set file permissions to 644
sudo find /var/www/html -type f -exec chmod 644 {} \;

# Verify no world-writable files
sudo find /var/www/html -type f -perm -002
# Should return empty

# Verify no world-writable directories
sudo find /var/www/html -type d -perm -002
# Should return empty
```

---

### 3. Create wp-config.php Securely

```bash
# Copy sample config
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Edit config
sudo nano /var/www/html/wp-config.php
```

**Required edits**:

#### A. Database Configuration
```php
define( 'DB_NAME', 'wordpress_db' );
define( 'DB_USER', 'wordpress_user' );
define( 'DB_PASSWORD', 'YOUR_STRONG_PASSWORD' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', 'utf8mb4_unicode_ci' );
```

#### B. Security Keys (CRITICAL)

Visit: https://api.wordpress.org/secret-key/1.1/salt/

Copy the generated keys and replace the placeholder section in wp-config.php.

#### C. Change Table Prefix (Security by Obscurity)
```php
$table_prefix = 'wp_abc123_';  // Change from default 'wp_'
```

#### D. Disable File Editing (CRITICAL)
```php
// Add at the end of wp-config.php, before "That's all"

// Disable file editing in admin
define('DISALLOW_FILE_EDIT', true);

// Disable file modifications (plugin/theme install/update via admin)
define('DISALLOW_FILE_MODS', true);

// Force SSL for admin (if using HTTPS)
define('FORCE_SSL_ADMIN', true);

// Limit post revisions
define('WP_POST_REVISIONS', 3);

// Enable auto-save interval (seconds)
define('AUTOSAVE_INTERVAL', 300);

// Disable debug display in production
define('WP_DEBUG', false);
define('WP_DEBUG_DISPLAY', false);
```

**Secure wp-config.php permissions**:
```bash
# Set to read-only for www-data
sudo chmod 440 /var/www/html/wp-config.php
sudo chown www-data:www-data /var/www/html/wp-config.php
```

**Verify**:
```bash
ls -l /var/www/html/wp-config.php
# Should show: -r--r----- 1 www-data www-data
```

---

## File System Hardening

### 1. Block PHP Execution in Uploads Directory

**This is CRITICAL to prevent shell uploads.**

**For Nginx**, edit your site config:
```bash
sudo nano /etc/nginx/sites-available/default
```

**Add inside server block**:
```nginx
# Block PHP execution in uploads directory
location ~* /wp-content/uploads/.*\.php$ {
    deny all;
}

# Block access to sensitive files
location ~ /\. {
    deny all;
}

location = /wp-config.php {
    deny all;
}

location = /readme.html {
    deny all;
}

location = /license.txt {
    deny all;
}
```

**Test and restart**:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

**Verify**:
```bash
# Create test PHP file in uploads
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/wp-content/uploads/test.php

# Try to access via browser:
# https://yoursite.com/wp-content/uploads/test.php
# Should get 403 Forbidden

# Remove test file
sudo rm /var/www/html/wp-content/uploads/test.php
```

---

### 2. Protect .htaccess (If Using Apache)

**Note**: If using Nginx, skip this section.

If you're using Apache instead of Nginx:
```bash
# Create .htaccess in uploads directory
sudo nano /var/www/html/wp-content/uploads/.htaccess
```

**Add**:
```apache
<Files *.php>
    deny from all
</Files>
```

---

### 3. Remove Unused Default Files

```bash
# Remove readme and license (information disclosure)
sudo rm /var/www/html/readme.html
sudo rm /var/www/html/license.txt

# Remove sample config (already have wp-config.php)
sudo rm /var/www/html/wp-config-sample.php
```

---

## WordPress Configuration Hardening

### 1. Disable XML-RPC (If Not Needed)

**XML-RPC is commonly abused for brute force attacks.**

**In Nginx config**:
```bash
sudo nano /etc/nginx/sites-available/default
```

**Add**:
```nginx
# Disable XML-RPC
location = /xmlrpc.php {
    deny all;
}
```

**Restart Nginx**:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

**Verify**:
```bash
curl -I https://yoursite.com/xmlrpc.php
# Should return 403 Forbidden
```

---

### 2. Limit Login Attempts

**Install Limit Login Attempts plugin** (after initial WordPress setup):

```bash
# After WordPress is accessible, install via WP-CLI
sudo -u www-data wp plugin install limit-login-attempts-reloaded --activate --path=/var/www/html
```

**Or manually**:
- Login to WordPress admin
- Go to Plugins → Add New
- Search "Limit Login Attempts Reloaded"
- Install and activate

**Configure**:
- Max attempts: 3
- Lockout time: 60 minutes
- Enable email notifications

---

### 3. Change Login URL (Optional)

**Use WPS Hide Login plugin**:
```bash
sudo -u www-data wp plugin install wps-hide-login --activate --path=/var/www/html
```

**Configure**:
- Settings → General
- Change "Login URL" to something unique (not "admin" or "login")
- Example: "secure-access-2024"

**New login**: `https://yoursite.com/secure-access-2024`

---

## Database Security

### 1. Change Database Prefix After Installation

**⚠️ CONFIRM REQUIRED**: This modifies database structure.

**Only do this if you changed table prefix in wp-config.php before installation.**

If you need to change it post-installation:

```bash
# Install Change Table Prefix plugin
sudo -u www-data wp plugin install change-table-prefix --activate --path=/var/www/html
```

**Use plugin UI to change prefix**, or manually via SQL (advanced).

---

### 2. Regular Database Backups

**Create backup script**:
```bash
nano ~/backup-db.sh
```

**Script**:
```bash
#!/bin/bash
# WordPress database backup

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/mysql"
DB_NAME="wordpress_db"
DB_USER="wordpress_user"
DB_PASS="YOUR_DB_PASSWORD"

mkdir -p "$BACKUP_DIR"

# Dump database
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_DIR/wp_db_$DATE.sql.gz"

# Keep only last 14 days
find "$BACKUP_DIR" -name "wp_db_*.sql.gz" -mtime +14 -delete

echo "Database backup completed: $DATE"
```

**Schedule daily**:
```bash
chmod +x ~/backup-db.sh
crontab -e
```

**Add**:
```cron
0 2 * * * /home/adminuser/backup-db.sh >> /var/log/backup-db.log 2>&1
```

---

## Nginx Security Configuration

### Complete Nginx Security Config

```bash
sudo nano /etc/nginx/sites-available/default
```

**Secure configuration**:
```nginx
server {
    listen 80;
    listen [::]:80;
    server_name yourdomain.com www.yourdomain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    root /var/www/html;
    index index.php index.html;

    # SSL certificates (via Certbot)
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    # SSL security settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers on;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Hide Nginx version
    server_tokens off;

    # Block access to hidden files
    location ~ /\. {
        deny all;
    }

    # Protect wp-config.php
    location = /wp-config.php {
        deny all;
    }

    # Protect readme and license
    location ~ /(readme|license)\.(html|txt) {
        deny all;
    }

    # Disable XML-RPC
    location = /xmlrpc.php {
        deny all;
    }

    # Block PHP execution in uploads
    location ~* /wp-content/uploads/.*\.php$ {
        deny all;
    }

    # Rate limiting for wp-login.php (DDoS protection)
    location = /wp-login.php {
        limit_req zone=login burst=2 nodelay;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    # WordPress permalinks
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    # PHP handling
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}

# Rate limiting zone (add to http block in /etc/nginx/nginx.conf)
# limit_req_zone $binary_remote_addr zone=login:10m rate=2r/m;
```

**Add rate limiting to main config**:
```bash
sudo nano /etc/nginx/nginx.conf
```

**Add inside http block**:
```nginx
# Rate limiting for login
limit_req_zone $binary_remote_addr zone=login:10m rate=2r/m;
```

**Test and restart**:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## Plugin & Theme Management

### 1. Minimal Plugin Philosophy

**Only install essential plugins. Each plugin increases attack surface.**

**Recommended minimum**:
1. **Security**: Wordfence Security or Sucuri Security
2. **Backups**: UpdraftPlus
3. **Login Protection**: Limit Login Attempts Reloaded
4. **SEO**: Yoast SEO or Rank Math (if needed)
5. **Caching**: WP Super Cache or W3 Total Cache (if NOT using Cloudflare)
6. **2FA**: Two-Factor (official plugin)

**Total plugins: Aim for less than 10**

---

### 2. Plugin Installation via WP-CLI (Recommended)

```bash
# Security plugin
sudo -u www-data wp plugin install wordfence --activate --path=/var/www/html

# Backup plugin
sudo -u www-data wp plugin install updraftplus --activate --path=/var/www/html

# Login limits
sudo -u www-data wp plugin install limit-login-attempts-reloaded --activate --path=/var/www/html

# Two-factor authentication
sudo -u www-data wp plugin install two-factor --activate --path=/var/www/html

# SEO (optional)
sudo -u www-data wp plugin install wordpress-seo --activate --path=/var/www/html
```

---

### 3. Enable Auto-Updates

```bash
# Enable auto-updates for all plugins
sudo -u www-data wp plugin auto-updates enable --all --path=/var/www/html

# Enable auto-updates for WordPress core
sudo -u www-data wp core update --path=/var/www/html
```

**In wp-config.php**, add:
```php
// Enable auto-updates for minor core releases
define('WP_AUTO_UPDATE_CORE', 'minor');
```

---

### 4. Remove Unused Themes

```bash
# List installed themes
sudo -u www-data wp theme list --path=/var/www/html

# Delete unused themes (keep only active theme and one default)
sudo -u www-data wp theme delete twentytwenty --path=/var/www/html
sudo -u www-data wp theme delete twentytwentyone --path=/var/www/html

# Keep active theme + one default (twentytwentythree) as fallback
```

---

### 5. Plugin Security Audit (Weekly)

```bash
# Check for plugin updates
sudo -u www-data wp plugin list --update=available --path=/var/www/html

# Update all plugins
sudo -u www-data wp plugin update --all --path=/var/www/html

# Check plugin status
sudo -u www-data wp plugin status --path=/var/www/html
```

---

## User Account Security

### 1. Change Default Admin Username

**⚠️ NEVER use "admin" as username.**

```bash
# Create new admin user with unique username
sudo -u www-data wp user create secureadmin admin@yourdomain.com \
  --role=administrator \
  --user_pass="$(openssl rand -base64 32)" \
  --display_name="Admin" \
  --path=/var/www/html

# Note the generated password!

# Login with new user, then delete old admin
sudo -u www-data wp user delete admin --yes --reassign=secureadmin --path=/var/www/html
```

---

### 2. Enforce Strong Passwords

**Install Force Strong Passwords plugin**:
```bash
sudo -u www-data wp plugin install force-strong-passwords --activate --path=/var/www/html
```

---

### 3. Enable Two-Factor Authentication

**After installing Two-Factor plugin**:

1. Login to WordPress admin
2. Go to Users → Your Profile
3. Scroll to "Two-Factor Options"
4. Enable "Email" or "Time-Based One-Time Password" (TOTP)
5. Configure with authenticator app (Google Authenticator, Authy)

**Enforce 2FA for all admins**:
- Install "Two Factor Authentication" plugin
- Settings → Two-Factor → Enable "Force 2FA for Administrators"

---

## Cloudflare Integration

**See detailed guide**: `/docs/ops/HOSTINGER_VPS_RUNBOOK.md` (Cloudflare Integration section)

**Quick checklist**:

### 1. DNS Setup
- [ ] Add site to Cloudflare
- [ ] Update nameservers at domain registrar
- [ ] Enable proxy (orange cloud) for main domain

### 2. SSL/TLS Settings
- [ ] SSL/TLS mode: **Full (strict)**
- [ ] Minimum TLS version: **1.2**
- [ ] Always use HTTPS: **Enabled**

### 3. Security Settings
- [ ] Security level: **Medium** or **High**
- [ ] Bot Fight Mode: **Enabled**
- [ ] Browser Integrity Check: **Enabled**

### 4. Firewall Rules

**Protect wp-login.php** (example):
```
(http.request.uri.path contains "/wp-login.php" and ip.geoip.country ne "IL")
Action: Challenge
```

**Rate limiting**:
```
(http.request.uri.path contains "/wp-login.php")
Rate: 5 requests per 1 minute
Action: Block for 1 hour
```

---

## Ongoing Maintenance

### Daily (Automated)
- [ ] Backup database (cron job)
- [ ] Monitor logs for errors

### Weekly (Manual)
- [ ] Check for WordPress core updates
- [ ] Check for plugin updates
- [ ] Check for theme updates
- [ ] Review security scan results (Wordfence)
- [ ] Review failed login attempts

### Monthly (Manual)
- [ ] Full backup verification (test restore)
- [ ] Review user accounts (delete inactive users)
- [ ] Audit plugin list (remove unused plugins)
- [ ] Check SSL certificate expiry
- [ ] Review Cloudflare analytics

### Quarterly (Manual)
- [ ] Rotate admin password
- [ ] Rotate database password
- [ ] Security audit (full site scan)
- [ ] Performance optimization
- [ ] Review backup retention policy

---

## Security Verification Checklist

Use this checklist to verify WordPress is properly hardened:

### File System
- [ ] Web files owned by www-data:www-data
- [ ] Directories: 755 permissions
- [ ] Files: 644 permissions
- [ ] wp-config.php: 440 permissions
- [ ] No world-writable files
- [ ] .git directory removed (if exists)

### WordPress Configuration
- [ ] DISALLOW_FILE_EDIT set to true
- [ ] DISALLOW_FILE_MODS set to true
- [ ] Security keys regenerated (not default)
- [ ] Table prefix changed from wp_
- [ ] Debug mode disabled (WP_DEBUG = false)
- [ ] XML-RPC disabled
- [ ] File editing disabled in admin

### Nginx/Web Server
- [ ] PHP execution blocked in uploads directory
- [ ] wp-config.php not accessible via browser
- [ ] Hidden files blocked
- [ ] Security headers configured
- [ ] HTTPS enforced (HTTP→HTTPS redirect)
- [ ] Rate limiting enabled for wp-login.php

### Database
- [ ] Strong database password
- [ ] Database user has minimal privileges
- [ ] MySQL bound to localhost only
- [ ] Regular backups scheduled

### Plugins & Themes
- [ ] Only essential plugins installed
- [ ] All plugins updated to latest versions
- [ ] Auto-updates enabled
- [ ] Security plugin active (Wordfence/Sucuri)
- [ ] Backup plugin active (UpdraftPlus)
- [ ] Unused themes deleted

### User Accounts
- [ ] No "admin" username exists
- [ ] All admin passwords are strong (20+ chars)
- [ ] Two-factor authentication enabled for admins
- [ ] No unnecessary user accounts

### Cloudflare
- [ ] Cloudflare proxy enabled
- [ ] SSL mode: Full (strict)
- [ ] Security level: Medium or High
- [ ] Firewall rules configured
- [ ] Rate limiting enabled

---

## Related Documentation

- [VPS Operations Runbook](/docs/ops/HOSTINGER_VPS_RUNBOOK.md)
- [Security Baseline](/docs/ops/HOSTINGER_SECURITY_BASELINE_UBUNTU.md)
- [Malware Response](/docs/ops/HOSTINGER_MALWARE_RESPONSE.md)
- [AI Agent Safety](/docs/ops/HOSTINGER_AI_AGENT_SAFETY.md)

---

**Last Updated**: 2025-12-31
