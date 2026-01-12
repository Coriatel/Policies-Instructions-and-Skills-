# RTL & Hebrew-First UI

## Purpose
כללים לבניית UI בעברית עם תמיכה מלאה ב-RTL.

---

## 1. עקרונות בסיסיים

### HTML Direction
```html
<!-- Set on html or body -->
<html dir="rtl" lang="he">
```

### CSS Logical Properties
```scss
// ❌ אסור (physical)
.element {
  margin-left: 16px;
  padding-right: 8px;
  text-align: left;
  float: right;
}

// ✅ נכון (logical)
.element {
  margin-inline-start: 16px;
  padding-inline-end: 8px;
  text-align: start;
  float: inline-end;
}
```

### Mapping Table
| Physical (LTR) | Logical | Hebrew Meaning |
|----------------|---------|----------------|
| left | inline-start | התחלה (ימין) |
| right | inline-end | סוף (שמאל) |
| top | block-start | למעלה |
| bottom | block-end | למטה |
| margin-left | margin-inline-start | margin התחלתי |
| margin-right | margin-inline-end | margin סופי |
| padding-left | padding-inline-start | padding התחלתי |
| padding-right | padding-inline-end | padding סופי |
| border-left | border-inline-start | border התחלתי |
| text-align: left | text-align: start | יישור להתחלה |

---

## 2. Flexbox ב-RTL

```scss
// Flexbox works automatically with RTL!
.container {
  display: flex;
  flex-direction: row; // RTL: starts from right
  justify-content: flex-start; // RTL: starts from right
}

// Reverse is also automatic
.container-reverse {
  flex-direction: row-reverse; // RTL: starts from left
}
```

---

## 3. תוכן מעורב (Mixed Content)

### URLs, Emails, Numbers
```jsx
// ❌ בעיה: URL נשבר ב-RTL
<p>בקר באתר https://example.com לפרטים</p>

// ✅ פתרון: dir="ltr" על התוכן הספציפי
<p>
  בקר באתר <span dir="ltr">https://example.com</span> לפרטים
</p>
```

### Phone Numbers
```jsx
// ❌ מספר טלפון נשבר
<p>טלפון: 054-1234567</p>

// ✅ נכון
<p>טלפון: <span dir="ltr">054-1234567</span></p>
```

### Code Snippets
```jsx
// Always LTR for code
<pre dir="ltr">
  const x = 1;
</pre>
```

---

## 4. Unicode Markers (כשצריך)

### LRM (Left-to-Right Mark)
```jsx
// \u200E - forces LTR context
const text = `טקסט בעברית \u200E(example@email.com)\u200E המשך`;
```

### RLM (Right-to-Left Mark)
```jsx
// \u200F - forces RTL context
const text = `\u200Fטקסט שחייב להתחיל מימין`;
```

### BDI Element (Best Practice)
```jsx
// Isolates bidirectional text
<p>
  המשתמש <bdi>{username}</bdi> התחבר
</p>
```

---

## 5. טבלאות RTL

### Headers
```scss
.table {
  text-align: start; // יישור לימין ב-RTL

  th, td {
    padding-inline-start: 12px;
    padding-inline-end: 8px;
  }
}
```

### Numbers in Tables
```scss
// Numbers should be LTR but aligned to end
.numeric-cell {
  direction: ltr;
  text-align: end; // מיושר לשמאל של התא
}
```

### Actions Column
```jsx
// Actions on the left (end) in RTL
<table dir="rtl">
  <thead>
    <tr>
      <th>שם</th>
      <th>תאריך</th>
      <th>פעולות</th> {/* Last column = left side in RTL */}
    </tr>
  </thead>
</table>
```

---

## 6. Forms RTL

### Labels and Inputs
```scss
.form-group {
  display: flex;
  flex-direction: column;
  align-items: flex-start; // RTL: right side

  label {
    margin-block-end: 4px;
  }

  input {
    text-align: start; // RTL: right-aligned text
    width: 100%;
  }
}
```

### Inline Forms
```scss
.inline-form {
  display: flex;
  gap: 8px;
  // Flexbox handles RTL automatically
}
```

### Placeholders
```jsx
<input
  placeholder="הכנס שם מלא"
  // Placeholder inherits direction
/>
```

---

## 7. i18n עם react-i18next

### Setup
```javascript
// i18n.js
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

i18n.use(initReactI18next).init({
  resources: {
    he: { translation: require('./locales/he.json') },
    en: { translation: require('./locales/en.json') },
  },
  lng: 'he', // Default to Hebrew
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
});
```

### Translation Files
```json
// locales/he.json
{
  "common": {
    "save": "שמור",
    "cancel": "ביטול",
    "delete": "מחק",
    "edit": "ערוך",
    "loading": "טוען..."
  },
  "errors": {
    "required": "שדה חובה",
    "invalidEmail": "כתובת אימייל לא תקינה"
  }
}

// locales/en.json
{
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit",
    "loading": "Loading..."
  },
  "errors": {
    "required": "Required field",
    "invalidEmail": "Invalid email address"
  }
}
```

### Usage
```jsx
import { useTranslation } from 'react-i18next';

function MyComponent() {
  const { t } = useTranslation();

  return (
    <button>{t('common.save')}</button>
  );
}
```

---

## 8. Icons ב-RTL

### Mirrored Icons
```scss
// Icons that should mirror in RTL
.icon-arrow-back {
  // Use transform for mirroring
  [dir="rtl"] & {
    transform: scaleX(-1);
  }
}

// Or use CSS logical values
.icon-container {
  margin-inline-end: 8px; // Works in both directions
}
```

### Icons That Don't Mirror
- Checkmarks
- X/Close
- Plus/Minus
- Social media logos
- Media controls (play/pause)

---

## 9. Testing RTL

### Manual Testing
1. Switch browser to Hebrew
2. Check all layouts
3. Test mixed content (URLs, numbers)
4. Test forms and inputs
5. Test tables and lists

### Automated Testing
```javascript
// Playwright test
test('RTL layout', async ({ page }) => {
  await page.goto('/');

  // Verify direction
  const html = await page.locator('html');
  await expect(html).toHaveAttribute('dir', 'rtl');

  // Verify text alignment
  const title = await page.locator('h1');
  const styles = await title.evaluate(el => getComputedStyle(el).textAlign);
  expect(styles).toBe('start');
});
```

---

## 10. Checklist

### כל קומפוננט חדש
- [ ] משתמש ב-CSS Logical Properties
- [ ] טקסטים מתורגמים (he + en)
- [ ] מספרים/URLs עם dir="ltr"
- [ ] נבדק ב-RTL mode

### Layout
- [ ] Flexbox עובד נכון
- [ ] Sidebar בצד ימין
- [ ] Actions בצד שמאל

### Typography
- [ ] Font תומך בעברית
- [ ] Line-height מתאים
- [ ] Letter-spacing מתאים (לא שלילי בעברית)

---

**Last Updated**: 2026-01
