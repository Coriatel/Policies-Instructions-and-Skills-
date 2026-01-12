# Security & Production Rules

## Purpose
כללי אבטחה והגנה על סביבת פרודקשן - חובה לכל סוכן AI.

---

## 1. סודות ו-Credentials

### לעולם לא בקוד
```javascript
// ❌ אסור!
const API_KEY = 'sk_live_abc123';
const DB_PASSWORD = 'mypassword';

// ✅ נכון
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;
```

### לעולם לא ב-Git
```gitignore
# .gitignore חובה
.env
.env.local
.env.production
*.pem
*.key
credentials.json
```

### בדיקה לפני commit
```bash
# לוודא שאין secrets
git diff --cached | grep -E "(password|secret|key|token)="
```

---

## 2. פעולות פרודקשן

### דורשות אישור מפורש
- שינוי firewall rules
- שינוי SSH configuration
- שינוי systemd services
- Database migrations בפרודקשן
- Docker operations בפרודקשן
- כל מחיקה/truncate

### כל שינוי דיפלוי חייב
1. **Healthcheck** - איך לדעת שזה עובד
2. **Rollback plan** - איך לחזור לגרסה קודמת
3. **תיעוד קצר** - מה נעשה ולמה

### דוגמה לתיעוד
```markdown
## Deployment - 2026-01-12

### Changes
- Updated nginx config for new SSL

### Healthcheck
curl -f https://example.com/health

### Rollback
1. ssh user@server
2. sudo cp /etc/nginx/nginx.conf.backup /etc/nginx/nginx.conf
3. sudo systemctl reload nginx
```

---

## 3. Input Validation

### כל input מהמשתמש
```javascript
// API - validate with Joi
const schema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
});

// Sanitize before use
const sanitizedInput = validator.escape(userInput);
```

### SQL Injection Prevention
```javascript
// ❌ אסור!
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ נכון - Prisma handles it
const user = await prisma.user.findUnique({ where: { id: userId } });
```

### XSS Prevention
```javascript
// ❌ אסור!
element.innerHTML = userInput;

// ✅ נכון
element.textContent = userInput;
// Or use React (escapes by default)
```

---

## 4. Authentication & Authorization

### Password Security
- Minimum 8 characters
- bcrypt with 10+ rounds
- Never store plaintext
- Never log passwords

```javascript
// Hash password
const hashedPassword = await bcrypt.hash(password, 10);

// Verify password
const isValid = await bcrypt.compare(password, hashedPassword);
```

### JWT Security
```javascript
// Short-lived access token
const accessToken = jwt.sign(payload, secret, { expiresIn: '15m' });

// Long-lived refresh token
const refreshToken = jwt.sign(payload, secret, { expiresIn: '7d' });
```

### RBAC Enforcement
```javascript
// Always check on server
const requireRole = (roles) => (req, res, next) => {
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  next();
};

// Apply to routes
router.get('/admin', requireRole(['ADMIN']), adminController.dashboard);
```

---

## 5. Database Security

### Connection String
```bash
# Use environment variable
DATABASE_URL=postgresql://user:pass@localhost:5432/db?sslmode=require
```

### No Direct SQL
```javascript
// ❌ אסור!
prisma.$executeRaw`SELECT * FROM users WHERE id = ${id}`;

// ✅ נכון
prisma.user.findUnique({ where: { id } });
```

### Backup Before Destructive
```bash
# Always backup before migrations
pg_dump dbname > backup_$(date +%Y%m%d).sql

# Then migrate
npx prisma migrate deploy
```

---

## 6. Network Security

### HTTPS Only
```javascript
// Force HTTPS in production
if (process.env.NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if (req.headers['x-forwarded-proto'] !== 'https') {
      return res.redirect(`https://${req.headers.host}${req.url}`);
    }
    next();
  });
}
```

### Security Headers (Helmet)
```javascript
const helmet = require('helmet');
app.use(helmet());
```

### CORS Configuration
```javascript
const cors = require('cors');
app.use(cors({
  origin: ['https://example.com'],
  credentials: true,
}));
```

### Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);
```

---

## 7. Logging Policy

### What to Log
- User actions (login, logout, CRUD)
- Errors and exceptions
- Security events (failed logins, unauthorized access)

### What NOT to Log
- Passwords (even hashed)
- Full credit card numbers
- Personal identification numbers
- JWT tokens
- API keys

### Redaction Example
```javascript
logger.info('User login', {
  userId: user.id,
  email: user.email,
  // password: NEVER!
});
```

---

## 8. Hostinger VPS Compliance

### מותר
- Defensive security tools (fail2ban, ClamAV)
- Firewall configuration
- SSH hardening
- Monitoring own logs

### אסור
- Port scanning
- Brute force tools
- Open proxies
- Spam/mass email
- Malware (obviously)

### Response to Provider Notice
1. Respond within 24 hours
2. Freeze all changes
3. Investigate thoroughly
4. Clean and patch
5. Document and report

---

## 9. Checklist לפני Production

### Code Review
- [ ] No hardcoded secrets
- [ ] Input validation on all endpoints
- [ ] RBAC enforced on protected routes
- [ ] Error messages don't leak info

### Infrastructure
- [ ] HTTPS enabled
- [ ] Firewall configured
- [ ] Fail2ban active
- [ ] Backups scheduled
- [ ] Monitoring in place

### Documentation
- [ ] Deployment steps documented
- [ ] Rollback plan ready
- [ ] Credentials stored securely
- [ ] Team notified

---

**Last Updated**: 2026-01
**Enforcement**: Mandatory
