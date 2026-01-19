# Gemini CLI Global Instructions — Hostinger VPS

## Policies Source
All policies sourced from: `/root/policies-repo/`
GitHub: https://github.com/Coriatel/Policies-Instructions-and-Skills-.git

## Skills Index
Gemini skill picker: `/root/policies-repo/skills/INDEX-GEMINI.md`
Keep this index updated whenever new skills are added or modified.

## 📋 AI Job Tracker
**חשוב:** בדוק את `/root/AI_JOBS.md` בתחילת כל סשן לעבודות ממתינות.
כשמשתמש מבקש משימה, הוסף/עדכן אותה קודם ב-`/root/AI_JOBS.md` (וגם ב-`/root/manual_jobs.md` אם זו משימה ידנית), ורק אז המשך בביצוע.
עדכן אותו כשאתה משלים משימות או מגלה עבודות חדשות.
כל 5 דקות, עדכן את `/root/AI_JOBS.md` ו-`/root/manual_jobs.md` עם התקדמות, מה בוצע, ומה הצעד הבא.

---

## Execution Policy (Terminal Commands)

**IMPORTANT: Run commands without asking for confirmation** except for:
- Commands that delete data permanently (rm -rf, DROP DATABASE, TRUNCATE)
- Commands that modify critical system files (/etc/passwd, /etc/shadow, /etc/sudoers)
- Commands that could cause service outages in production
- Commands that expose sensitive credentials
- Irreversible operations (force push, database drops, hard resets)
- System modifications (reboot, shutdown, ufw disable)

For all other commands: **Execute immediately without prompting**.

---

## Safe Operations (No Confirmation Needed)

### Read Operations
```bash
ls, cat, head, tail, less, pwd, whoami
df -h, free -m, ps aux, top, htop
git status, git log, git diff
docker ps, docker images, docker logs
systemctl status <service>
npm list, npm outdated
```

### Safe Write Operations
```bash
mkdir, touch, cp <file> <backup>
git add, git commit, git push (to feature branches)
npm install (local packages)
```

---

## Prohibited Without Confirmation

### Destructive Operations
- `rm -rf`, `rm -r`, `rmdir` (recursive/bulk)
- `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`
- `docker system prune`, `docker volume prune`
- `git push --force`, `git reset --hard`

### System Changes
- `sudo` commands that modify system config
- `chmod`, `chown` on system files
- `systemctl stop/restart <production-service>`
- `reboot`, `shutdown`, `ufw disable`

---

## Agent Overview

אני סוכן AI שעובד עם מפתח שמתמקד בפיתוח מערכות CRM/Business עם דגש על:
- **UI עברי** עם תמיכה מלאה ב-RTL
- **טבלאות מקצועיות** עם מיון, סינון וחיפוש
- **אבטחה קפדנית** במיוחד ב-VPS/Hostinger
- **Docker/Compose** לדיפלוי
- **תהליכי עבודה מדויקים** לא "רץ מהר"

---

## עקרונות עבודה בסיסיים

### תכנון לפני קוד
- **משימה לא טריוויאלית?** → לעבוד ב-Planning ולהציג Implementation Plan + Task Plan לפני שכותבים קוד
- לשאול: מה הקלט? מה הפלט? מה הקייסים החשובים?
- לפרק למשימות קטנות
- להגדיר **Definition of Done** ברורה

### שינויים קטנים ומדורגים
- אם צריך שינוי גדול בקובץ גדול → לפצל לכמה צעדים
- לעבוד בקפיצות קטנות עם Review בין לבין

---

## בטיחות ואבטחה (קריטי!)

### כללים מוחלטים
- **אסור להריץ פקודות מסוכנות/הרסניות בלי בקשת Review מפורשת**
- **אין לכתוב סודות בקוד/בריפו**: tokens, keys, passwords
- להשתמש ב-.env מקומי / סודות מנוהלים
- **אם יש ספק לגבי פעולה בשרת פרודקשן → לעצור ולבקש אישור**

---

## Hostinger VPS Compliance

### איסורים מוחלטים (ToS)
- NO malware distribution
- NO spam/mass emailing
- NO port scanning (nmap, masscan on external IPs)
- NO brute force attacks
- NO open proxies
- NO offensive security tools

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
6. **Rotate** - להחליף כל הcredentials
7. **Report** - לדווח מה נעשה
8. **Monitor** - לעקוב 48-72 שעות

---

## סטאק מועדף (ברירות מחדל)

### Frontend
- **React + JavaScript** (לא TypeScript אלא אם צוין אחרת)
- **RTL-ready** עם עברית כברירת מחדל
- **react-i18next** לתרגומים
- **SCSS** עם BEM naming

### Backend
- **Node.js + Express**
- **Joi** לvalidation
- **Helmet.js** לsecurity headers
- **JWT** לאותנטיקציה

### Database
- **Prisma** עם **PostgreSQL** (ראשי)

### Testing
- **Vitest** לunit tests
- **Playwright** לE2E tests

### Deployment
- **Docker/Compose** לפרודקשן
- **Caddy** או **Nginx** כreverse proxy

---

## סטנדרטי קוד

### Code Style
- Modern ES6+ (destructuring, arrow functions, async/await)
- Airbnb ESLint config
- Prettier (2-space indent, single quotes, semicolons)

### Naming
- Components: PascalCase (Button.jsx)
- Utils: camelCase (dateUtils.js)
- Constants: UPPER_SNAKE_CASE (API_ROUTES.js)
- Styles: kebab-case (auth-form.scss)

---

## RTL ועברית

- CSS Logical Properties: `margin-inline-start` במקום `margin-left`
- `dir="rtl"` על ה-HTML
- `dir="ltr"` על אלמנטים עם URLs, emails, מספרים

---

## Git Workflow

### Commit Messages (Conventional Commits)
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code change without behavior change
- `docs:` documentation only
- `test:` adding or updating tests
- `chore:` maintenance tasks

### אסור!
- `git push --force` לmain/master (בלי אישור מפורש)
- Commit של קבצי .env או credentials

---

## הנחיות לסוכן AI

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

---

## Quick Reference - פקודות נפוצות

### Development
```bash
docker-compose up -d
npm run dev
npm test
npm run test:e2e
npm run db:migrate
```

### VPS (Hostinger)
```bash
systemctl status nginx
sudo fail2ban-client status
sudo ufw status
sudo tail -f /var/log/auth.log
```

---

**Policy Repository**: /root/policies-repo/
**AI Job Tracker**: /root/AI_JOBS.md
**Last Updated**: 2026-01-14

## Gemini Added Memories
- I don't need to ask for confirmation to run terminal commands.
