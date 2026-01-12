# /plan-and-split

**Global Workflow** - לתכנון משימה לפני כתיבת קוד

## מתי להשתמש
- כשמקבלים משימה גדולה או לא ברורה
- כשצריך לפרק feature למשימות קטנות
- כשרוצים להבין scope לפני שמתחילים

## הצעדים

### 1. הבנת הדרישות
שאלות לבירור:
- **מה הקלט?** (מאיפה מגיע המידע)
- **מה הפלט?** (מה המשתמש צריך לראות/לקבל)
- **מה הקייסים החשובים?** (happy path, edge cases, errors)
- **מה מחוץ לscope?** (מה לא לעשות עכשיו)

### 2. פירוק למשימות
יצירת רשימת משימות:
```markdown
## Task Breakdown

### Phase 1: Foundation
- [ ] משימה 1 (30 דקות)
- [ ] משימה 2 (45 דקות)

### Phase 2: Implementation
- [ ] משימה 3 (60 דקות)
- [ ] משימה 4 (45 דקות)

### Phase 3: Testing & Polish
- [ ] משימה 5 (30 דקות)
- [ ] משימה 6 (30 דקות)
```

### 3. Checkpoints
הגדרת נקודות עצירה:
- **Checkpoint 1**: אחרי Phase 1 - לוודא foundation עובד
- **Checkpoint 2**: אחרי Phase 2 - לוודא feature עובד
- **Checkpoint 3**: אחרי Phase 3 - ready for review

### 4. Definition of Done
```markdown
## Definition of Done

### Code
- [ ] קוד עובד לכל הקייסים
- [ ] אין errors בקונסול
- [ ] Lint עובר בלי warnings

### Tests
- [ ] Unit tests למודולים חדשים
- [ ] Integration tests לAPI
- [ ] E2E לflow הראשי

### Documentation
- [ ] Comments במקומות לא ברורים
- [ ] תיעוד API אם רלוונטי
- [ ] Update README אם צריך

### RTL/i18n
- [ ] UI עובד ב-RTL
- [ ] טקסטים מתורגמים (he + en)
```

### 5. Dependencies ו-Blockers
```markdown
## תלויות
- [ ] צריך API endpoint של... (מגיע מ...)
- [ ] צריך design של... (מגיע מ...)

## Blockers פוטנציאליים
- אם X לא עובד, נצטרך לעשות Y
```

---

**Output**: Implementation Plan מפורט שאפשר לעקוב אחריו
