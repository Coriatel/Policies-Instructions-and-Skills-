# /deploy-hostinger-safe

**Global Workflow** - דיפלוי בטוח ל-Hostinger VPS

## מטרה
דיפלוי בטוח שבו הסוכן לא מריץ SSH/פקודות הרסניות לבד - רק מכין Runbook להרצה ידנית.

## מתי להשתמש
- דיפלוי ראשון לשרת
- עדכון גרסה בפרודקשן
- שינויי configuration בשרת

## חשוב!
**הסוכן לא מריץ SSH לבד** - הוא מכין הכל ואתה מריץ.

---

## הצעדים

### 1. איסוף נתוני פרודקשן
בדיקת קבצי ה-deployment הקיימים:

```markdown
## Environment Check
- [ ] docker-compose.yml קיים ותקין
- [ ] .env.example עם כל המשתנים הנדרשים
- [ ] Caddy/Nginx config קיים
- [ ] Healthcheck מוגדר
```

### 2. Runbook דיפלוי
הכנת פקודות מדויקות להרצה ידנית:

```markdown
## Deployment Runbook

### A. התחברות לשרת
ssh -i ~/.ssh/hostinger_key user@YOUR_IP

### B. גיבוי לפני שינוי
# Database backup
docker exec postgres pg_dump -U user dbname > /backups/pre-deploy-$(date +%Y%m%d_%H%M%S).sql

# Current image
docker tag myapp:current myapp:rollback-$(date +%Y%m%d)

### C. Pull latest code
cd /opt/myapp
git fetch origin main
git pull origin main

### D. Build and deploy
docker-compose build
docker-compose up -d

### E. Verify
docker-compose ps
curl -f http://localhost:3000/health

### F. Check logs
docker-compose logs --tail=100 -f
```

### 3. בדיקות אימות
לכל שלב - איך לוודא שהוא עבר:

```markdown
## Verification Steps

### After build:
docker images | grep myapp
# צריך לראות את ה-image החדש

### After up:
docker-compose ps
# כל הservices צריכים להיות "Up"

### Health check:
curl -f http://localhost:3000/health
# צריך לקבל 200 OK

### Logs check:
docker-compose logs --tail=50 app
# לוודא שאין errors
```

### 4. Rollback Plan
איך לחזור אחורה אם משהו נשבר:

```markdown
## Rollback Steps (אם צריך!)

### Quick rollback (image)
docker-compose down
docker tag myapp:rollback-YYYYMMDD myapp:current
docker-compose up -d

### Database rollback (אם שינינו schema)
docker exec -i postgres psql -U user dbname < /backups/pre-deploy-YYYYMMDD_HHMMSS.sql

### Code rollback
git checkout HEAD~1
docker-compose build
docker-compose up -d
```

### 5. Post-Deploy Monitoring
```markdown
## Monitor for 30 minutes

### Watch logs:
docker-compose logs -f

### Watch resources:
htop
# or
docker stats

### Check for errors:
tail -f /var/log/nginx/error.log
```

---

## Output Format

הסוכן יפיק מסמך בפורמט:

```markdown
# Deployment Runbook - [Project Name] - [Date]

## Pre-Deploy Checklist
- [ ] Backup database
- [ ] Tag current image
- [ ] Notify team

## Deploy Commands
[פקודות מדויקות להעתקה]

## Verify Commands
[פקודות לאימות]

## Rollback Commands
[פקודות לחזרה אחורה]

## Post-Deploy
- [ ] Monitor logs 30 min
- [ ] Test critical flows
- [ ] Update documentation
```

---

## אזהרות

**הסוכן לא יריץ:**
- ssh
- scp
- rsync לשרתים
- docker-compose up על שרת מרוחק
- שום דבר שמשנה פרודקשן

**הסוכן כן יכול:**
- לקרוא קבצי config
- להכין Runbooks
- לכתוב scripts (בלי להריץ)
- לענות על שאלות

---

**Last Updated**: 2026-01
