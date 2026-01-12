# /ship-it

**Global Workflow** - לסיום משימה בצורה בטוחה וניתנת לאימות

## מתי להשתמש
- בסיום משימת פיתוח
- לפני merge/push
- כ-checklist אחרון לפני דיפלוי

## הצעדים

### 1. סיכום שינויים
הצג רשימה קצרה של מה השתנה:
```markdown
## שינויים
- [+] נוסף: <תיאור>
- [~] שונה: <תיאור>
- [-] הוסר: <תיאור>
```

### 2. הוראות בדיקה מקומית
```bash
# פקודות להרצה
npm test
npm run lint
npm run build
```

### 3. אימות ידני UI
רשימת צעדים קצרה לבדיקה ידנית:
1. פתח את... בדפדפן
2. נווט אל...
3. בדוק ש...

### 4. שינויי Database (אם רלוונטי)
```bash
# Migration
npm run db:migrate

# Seed (אם צריך)
npm run db:seed

# Rollback (אם צריך לחזור)
npm run db:migrate:rollback
```

### 5. סיכונים ותשומת לב
רשום נקודות חשובות:
- Breaking changes?
- Environment variables חדשים?
- תלויות חדשות?
- שינויי API?

---

**Output**: סיכום שלם שניתן להעתיק לPR description או לתיעוד
