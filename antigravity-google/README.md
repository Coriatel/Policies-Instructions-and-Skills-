# Google Antigravity - Development Policy Setup

**מדריך מקיף להגדרת Antigravity Google עם מדיניות פיתוח, אבטחה ו-Workflows**

---

## 📋 תוכן עניינים

1. [מבוא](#מבוא)
2. [מבנה התיקיות](#מבנה-התיקיות)
3. [התקנה מהירה](#התקנה-מהירה)
4. [הגדרות אבטחה](#הגדרות-אבטחה)
5. [Global Rules](#global-rules)
6. [Global Workflows](#global-workflows)
7. [Workspace Rules](#workspace-rules)
8. [Workspace Workflows](#workspace-workflows)
9. [MCP Configuration](#mcp-configuration)
10. [שיטת עבודה מומלצת](#שיטת-עבודה-מומלצת)

---

## מבוא

### מה זה Antigravity?
Antigravity הוא IDE של Google שמאפשר עבודה עם סוכני AI. יש לו שני מסכים מרכזיים:
- **Agent Manager (Mission Control)** - ניהול כמה סוכנים במקביל
- **Editor** - עריכה רגילה בסגנון VS Code

### מצבי עבודה
- **Planning** - למשימות גדולות, מייצר Implementation Plan ו-Artifacts
- **Fast** - לתיקונים קטנים ומהירים

### מה זה Rules ו-Workflows?
- **Rules** = מדיניות וכללים (מה מותר/אסור, איך לכתוב קוד)
- **Workflows** = תהליכים שמופעלים עם `/command` (כמו `/ship-it`)

---

## מבנה התיקיות

```
~/.gemini/                              # Global (כל הפרויקטים)
├── GEMINI.md                           # Global Rules
├── antigravity/
│   ├── global_workflows/               # Global Workflows
│   │   ├── ship-it.md
│   │   ├── plan-and-split.md
│   │   ├── generate-tests.md
│   │   └── deploy-hostinger-safe.md
│   └── browserAllowlist.txt            # Allowed URLs for browser

your-workspace/                          # Workspace-specific
└── .agent/
    ├── rules/                          # Workspace Rules
    │   ├── project-context.md
    │   ├── security-and-prod.md
    │   └── rtl-hebrew.md
    └── workflows/                      # Workspace Workflows
        ├── add-api-route.md
        └── add-react-table.md
```

---

## התקנה מהירה

### שלב 1: העתקת Global Files

```bash
# Create directories
mkdir -p ~/.gemini/antigravity/global_workflows

# Copy global rule
cp antigravity-google/global/GEMINI.md ~/.gemini/GEMINI.md

# Copy global workflows
cp antigravity-google/global/global_workflows/*.md ~/.gemini/antigravity/global_workflows/
```

### שלב 2: הגדרת Workspace

```bash
# In your project directory
mkdir -p .agent/rules .agent/workflows

# Copy workspace rules
cp antigravity-google/workspace-template/.agent/rules/*.md .agent/rules/

# Copy workspace workflows
cp antigravity-google/workspace-template/.agent/workflows/*.md .agent/workflows/
```

### שלב 3: התאמה אישית

1. ערוך `.agent/rules/project-context.md` עם פרטי הפרויקט שלך
2. עדכן את הסטאק הטכנולוגי אם צריך
3. הוסף rules/workflows ספציפיים לפרויקט

---

## הגדרות אבטחה

### Terminal Execution Policy

**הגדרה מומלצת:** Auto + Denylist

#### Denylist (להוסיף ב-Settings)
```
rm
rmdir
del
shred
dd
mkfs
sudo
chmod
chown
usermod
curl
wget
ssh
scp
rsync
reboot
shutdown
systemctl stop
ufw disable
iptables
powershell
Invoke-WebRequest
```

### Review Policy

**הגדרה מומלצת:** Agent Decides או Request Review

- **Agent Decides** = הסוכן מחליט מתי לבקש review
- **Request Review** = תמיד מבקש review לפני שינויים

### JavaScript Execution Policy

**הגדרה מומלצת:** Request Review

מקטין סיכון Prompt Injection מאתרים חיצוניים.

### Browser URL Allowlist

ערוך את `~/.gemini/antigravity/browserAllowlist.txt`:

```
antigravity.google
developers.google.com
cloud.google.com
github.com
docs.github.com
npmjs.com
support.hostinger.com
hostinger.com
stackoverflow.com
```

---

## Global Rules

### מיקום
`~/.gemini/GEMINI.md`

### תוכן עיקרי
הקובץ מכיל:
- עקרונות עבודה (תכנון לפני קוד, Definition of Done)
- כללי אבטחה (פקודות מסוכנות, סודות)
- סטאק מועדף (React, Node, Prisma, Docker)
- סטנדרטי קוד (ESLint, Prettier, naming)
- RTL/Hebrew guidelines
- RBAC principles
- Git workflow
- Hostinger VPS compliance
- הנחיות לסוכן AI

### דוגמה
```markdown
## בטיחות ואבטחה (קריטי!)
- אסור להריץ פקודות מסוכנות בלי אישור
- אין לכתוב סודות בקוד/בריפו
- אם יש ספק לגבי פעולה בשרת פרודקשן → לעצור ולבקש אישור
```

---

## Global Workflows

### מיקום
`~/.gemini/antigravity/global_workflows/`

### Workflows זמינים

#### `/ship-it`
לסיום משימה בצורה בטוחה:
1. סיכום שינויים
2. הוראות בדיקה מקומית
3. אימות ידני UI
4. שינויי Database
5. סיכונים ותשומת לב

#### `/plan-and-split`
לתכנון משימה לפני קוד:
1. הבנת דרישות (קלט/פלט/קייסים)
2. פירוק למשימות קטנות
3. Checkpoints
4. Definition of Done

#### `/generate-tests`
ליצירת בדיקות:
1. זיהוי מה לבדוק
2. Unit tests (Vitest)
3. Integration tests (API)
4. E2E tests (Playwright)

#### `/deploy-hostinger-safe`
דיפלוי בטוח ל-Hostinger:
1. איסוף נתוני פרודקשן
2. הכנת Runbook להרצה ידנית
3. בדיקות אימות
4. Rollback plan

**חשוב:** הסוכן לא מריץ SSH לבד - רק מכין Runbook!

---

## Workspace Rules

### מיקום
`your-workspace/.agent/rules/`

### קבצים

#### `project-context.md`
- מטרת הפרויקט
- סטאק טכנולוגי
- UX/UI עקרונות
- File structure
- Naming conventions
- API conventions

#### `security-and-prod.md`
- ניהול סודות
- פעולות פרודקשן
- Input validation
- Authentication
- Database security
- Hostinger compliance

#### `rtl-hebrew.md`
- CSS Logical Properties
- Flexbox ב-RTL
- תוכן מעורב
- טבלאות RTL
- Forms RTL
- i18n setup

---

## Workspace Workflows

### מיקום
`your-workspace/.agent/workflows/`

### Workflows זמינים

#### `/add-api-route`
הוספת API endpoint חדש:
1. Route file
2. Controller
3. Validation schema
4. Registration
5. Prisma schema
6. Testing

#### `/add-react-table`
הוספת טבלת נתונים:
1. Table component
2. SCSS styles (RTL-ready)
3. Translations
4. Usage example

---

## MCP Configuration

### גישה דרך UI
1. Agent Manager → ... → MCP Servers
2. בחר מה-MCP Store
3. הכנס credentials

### גישה לקובץ Raw
```
... → MCP Servers → Manage MCP Servers → View raw config
```

מיקום: `mcp_config.json`

### שימושי עבור
- GitHub integration
- Database tooling
- External APIs

**אזהרה:** לא לשים PAT/סודות בתוך הריפו!

---

## שיטת עבודה מומלצת

### משימה גדולה

1. **פתח ב-Agent Manager** עם מצב Planning

2. **כתוב פרומפט מפורט:**
   ```
   מטרה: [תיאור המטרה]
   קונטקסט: [מה קיים, מה המצב]
   אילוצים: [RTL, Prisma, Docker, etc.]
   Definition of Done: [מה צריך להיות בסוף]
   ```

3. **דרוש Implementation Plan + Task Plan** (Artifacts) לפני קוד

4. **עיין ותן הערות** על התוכנית

5. **בזמן קוד:**
   - לעבוד בקפיצות קטנות
   - "Review changes" בין לבין
   - "Undo changes up to this point" אם משהו התחרבש

6. **לפני סיום:** הפעל `/ship-it`

### דיפלוי/שרת

תמיד דרך `/deploy-hostinger-safe`:
- הסוכן לא עושה SSH לבד
- מכין Runbook מדויק
- אתה מריץ את הפקודות
- יש rollback plan

### תיקונים קטנים

השתמש במצב **Fast**:
- תיקוני באגים פשוטים
- שינויי styling
- עדכוני תרגומים

---

## טיפים נוספים

### כשהסוכן נתקע
1. בדוק את ה-Artifacts שנוצרו
2. תן הנחיות יותר ספציפיות
3. השתמש ב-"Undo" וחזור לנקודה טובה

### כשצריך לבדוק משהו
1. בקש מהסוכן להריץ commands
2. בדוק Artifacts (screenshots, recordings)
3. השתמש בדפדפן המובנה לאימות UI

### כשעובדים על VPS
1. תמיד `/deploy-hostinger-safe`
2. לא נותנים לסוכן SSH access
3. עוקבים אחרי Runbook ידנית
4. שומרים logs ו-backups

---

## קבצים להתאמה אישית

### חובה להתאים
1. `.agent/rules/project-context.md` - פרטי הפרויקט
2. `browserAllowlist.txt` - domains שאתה סומך עליהם

### אופציונלי להתאים
1. `GEMINI.md` - אם יש כללים גלובליים נוספים
2. Workflows - אם יש תהליכים ייחודיים לפרויקט

---

## קישורים שימושיים

- [Google Antigravity Codelab](https://codelabs.developers.google.com/getting-started-google-antigravity)
- [MCP Documentation](https://docs.cloud.google.com/bigquery/docs/pre-built-tools-with-mcp-toolbox)
- [Development Policy Library](../README.md)

---

**Last Updated**: 2026-01
**Compatible With**: Google Antigravity (latest)
