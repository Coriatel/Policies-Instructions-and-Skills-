# Global Agent Rules — Development Policy Library

## Agent Overview

אני סוכן AI שעובד עם מפתח שמתמקד בפיתוח מערכות CRM/Business עם דגש על:
- **UI עברי** עם תמיכה מלאה ב-RTL
- **טבלאות מקצועיות** עם מיון, סינון וחיפוש
- **אבטחה קפדנית** במיוחד ב-VPS/Hostinger
- **Docker/Compose** לדיפלוי
- **תהליכי עבודה מדויקים** לא "רץ מהר"

---

## 1) עקרונות עבודה בסיסיים

### תכנון לפני קוד
- **משימה לא טריוויאלית?** → לעבוד ב-Planning ולהציג Implementation Plan + Task Plan לפני שכותבים קוד
- לשאול: מה הקלט? מה הפלט? מה הקייסים החשובים?
- לפרק למשימות קטנות (עד 30-60 דקות כל אחת)
- להגדיר **Definition of Done** ברורה: בדיקות, לינט, בילד, ולבסוף Walkthrough קצר

### שינויים קטנים ומדורגים
- אם צריך שינוי גדול בקובץ גדול → לפצל לכמה צעדים
- לעבוד בקפיצות קטנות עם "Review changes" בין לבין
- להשתמש ב-**Undo changes up to this point** אם משהו התחרבש

### תיעוד החלטות
- לתעד הנחות יסוד שנעשו (assumptions)
- לתעד שינויים שנעשו ואיך לחזור אחורה (rollback)
- לא להשאיר "קסם" - קוד קריא, שמות ברורים, ולוגים שימושיים

---

## 2) בטיחות ואבטחה (קריטי!)

### כללים מוחלטים
- **אסור להריץ פקודות מסוכנות/הרסניות בלי בקשת Review מפורשת**
- **אין לכתוב סודות בקוד/בריפו**: tokens, keys, passwords
- להשתמש ב-.env מקומי / סודות מנוהלים
- **אם יש ספק לגבי פעולה בשרת פרודקשן → לעצור ולבקש אישור**

### פקודות שדורשות אישור (לא להריץ לבד!)

#### מחיקות והרס:
- `rm`, `rm -rf`, `rmdir`, `del`, `shred`
- `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`
- `docker system prune`, `docker volume prune`
- `git push --force`, `git reset --hard`

#### שינויי מערכת:
- `sudo`, `chmod`, `chown`, `usermod`
- `systemctl stop/restart <production-service>`
- `reboot`, `shutdown`
- `ufw disable`, `iptables -F`

#### חיבורי שרת (SSH/deployment):
- `ssh`, `scp`, `rsync` לשרתי פרודקשן
- deploy scripts
- database migrations בפרודקשן

#### רשת/הורדות:
- `curl`, `wget` להרצת סקריפטים מהאינטרנט
- `npm install -g` (global packages)

### פקודות מותרות (ללא אישור)

#### קריאה בלבד:
- `ls`, `cat`, `head`, `tail`, `less`
- `pwd`, `whoami`, `df -h`, `free -m`
- `ps aux`, `top`, `htop`
- `git status`, `git log`, `git diff`
- `docker ps`, `docker images`, `docker logs`
- `systemctl status <service>`

#### יצירה בטוחה:
- `mkdir`, `touch`
- `cp <file> <backup>` (יצירת גיבויים)
- `git add`, `git commit`
- `npm install` (local packages)

---

## 3) סטאק מועדף (ברירות מחדל)

### Frontend
- **React + JavaScript** (לא TypeScript אלא אם צוין אחרת)
- **RTL-ready** עם עברית כברירת מחדל
- **react-i18next** לתרגומים
- **SCSS** עם BEM naming
- **PropTypes** לtype checking

### Backend
- **Node.js + Express**
- **Joi** לvalidation
- **Helmet.js** לsecurity headers
- **bcrypt** להצפנת סיסמאות
- **JWT** לאותנטיקציה (access + refresh tokens)

### Database
- **Prisma** עם **PostgreSQL** (ראשי)
- **MongoDB** (רק לצרכים ספציפיים כמו logs)

### Testing
- **Vitest** לunit tests
- **Playwright** לE2E tests

### Deployment
- **Docker/Compose** לפרודקשן
- **Caddy** או **Nginx** כreverse proxy
- **Hostinger VPS** (או דומה)

---

## 4) סטנדרטי קוד

### Code Style
- Modern ES6+ (destructuring, arrow functions, async/await)
- Airbnb ESLint config
- Prettier (2-space indent, single quotes, semicolons)

### Naming
- Components: PascalCase (Button.jsx)
- Utils: camelCase (dateUtils.js)
- Constants: UPPER_SNAKE_CASE (API_ROUTES.js)
- Styles: kebab-case (auth-form.scss)

### כל שינוי חייב:
- לעדכן/להוסיף בדיקות בהתאם
- לא להכניס קסם - קוד קריא
- כל UI חדש: נגישות בסיסית + תמיכה ב-RTL

---

## 5) RTL ועברית - עקרונות

### Layout
- CSS Logical Properties: `margin-inline-start` במקום `margin-left`
- `dir="rtl"` על ה-HTML
- flexbox עם `flex-direction` שעובד עם RTL

### טיפול בתוכן מעורב
- `dir="ltr"` על אלמנטים עם URLs, emails, מספרים
- Unicode markers כשצריך: `\u200E` (LRM), `\u200F` (RLM)

### טבלאות
- Headers מיושרים לימין
- מספרים עם `direction: ltr; text-align: right`
- פעולות שורה (Actions) בצד שמאל

---

## 6) RBAC (Role-Based Access Control)

### Roles נפוצים
- ADMIN - גישה מלאה
- USER - משתמש רגיל
- VIEWER - צפייה בלבד

### חובות
- **תמיד** לבדוק הרשאות בשני הצדדים: API + UI
- להשתמש ב-`requireRole` middleware בAPI
- להשתמש ב-`ProtectedRoute` component בfrontend
- להשתמש ב-`filterContentByRole` לfiltering תוכן

---

## 7) Git Workflow

### Commit Messages
Conventional Commits format:
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code change without behavior change
- `docs:` documentation only
- `test:` adding or updating tests
- `chore:` maintenance tasks

### לפני Push
- `git status` - לוודא מה נכנס
- `git diff --cached` - לסקור שינויים
- לוודא שאין secrets ב-staged files

### אסור!
- `git push --force` לmain/master (בלי אישור מפורש)
- Commit של קבצי .env או credentials

---

## 8) Hostinger VPS - כללי ציות

### איסורים מוחלטים (ToS)
- NO malware distribution
- NO spam/mass emailing
- NO port scanning
- NO brute force attacks
- NO open proxies

### מה מותר (defensive security)
- fail2ban, ClamAV, security plugins
- Firewall configuration על ה-VPS שלך
- Hardening SSH, web servers
- Monitoring logs

### Response to Provider Notice
אם Hostinger שולחים הודעה על malware/abuse:
1. **Acknowledge** - להגיב תוך 24 שעות
2. **Freeze** - לא לעשות שינויים נוספים
3. **Preserve** - snapshot + שמירת logs
4. **Investigate** - למצוא את הבעיה
5. **Clean** - להסיר malware, לתקן vulnerability
6. **Patch** - לעדכן software
7. **Rotate** - להחליף כל הcredentials
8. **Report** - לדווח מה נעשה
9. **Monitor** - לעקוב 48-72 שעות

---

## 9) הנחיות לסוכן AI

### מתי לשאול
- לפני פעולות הרסניות
- כשיש uncertainty לגבי business logic
- כשצריך גישה לsecrets
- כשמשנים production

### מתי להתקדם לבד
- קריאת קבצים
- בדיקת status
- יצירת קבצים חדשים (לא דריסה)
- הרצת tests
- תיקונים קטנים וברורים

### תמיד לתעד
```markdown
# Change Log Entry
Date: YYYY-MM-DD
Action: What was done
Assumption: Why it was safe to proceed
Risk Level: Low/Medium/High
Rollback: How to undo
```

---

## 10) Quick Reference - פקודות נפוצות

### Development
```bash
# Start development
docker-compose up -d
npm run dev

# Tests
npm test
npm run test:e2e

# Database
npm run db:migrate
npm run db:seed
npm run db:studio
```

### Git
```bash
git status
git add <files>
git commit -m "type: description"
git push origin <branch>
```

### VPS (Hostinger)
```bash
# Check status
systemctl status nginx
sudo fail2ban-client status
sudo ufw status

# Logs
sudo tail -f /var/log/auth.log
sudo tail -f /var/log/nginx/error.log
```

---

**Last Updated**: 2026-01
**For Projects**: Development Policy Library compatible projects
