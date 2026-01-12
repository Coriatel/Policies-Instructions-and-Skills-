# /generate-tests

**Global Workflow** - ליצירת בדיקות למודול/feature

## מתי להשתמש
- אחרי כתיבת קוד חדש
- כשמשנים לוגיקה קיימת
- כשמתקנים bug (test שמוכיח את התיקון)

## הצעדים

### 1. זיהוי מה לבדוק
```markdown
## Coverage Plan

### Unit Tests (logic)
- [ ] פונקציה X - קלט תקין
- [ ] פונקציה X - קלט לא תקין
- [ ] פונקציה X - edge cases

### Integration Tests (API)
- [ ] Endpoint GET /resource
- [ ] Endpoint POST /resource
- [ ] Endpoint עם הרשאות שונות

### E2E Tests (flows)
- [ ] User journey: login → action → result
```

### 2. Unit Tests (Vitest)
```javascript
// fileName.test.js
import { describe, it, expect, vi } from 'vitest';
import { functionToTest } from './fileName';

describe('functionToTest', () => {
  it('should handle valid input', () => {
    const result = functionToTest(validInput);
    expect(result).toBe(expectedOutput);
  });

  it('should handle invalid input', () => {
    expect(() => functionToTest(invalidInput)).toThrow();
  });

  it('should handle edge case', () => {
    const result = functionToTest(edgeCase);
    expect(result).toBe(edgeCaseOutput);
  });
});
```

### 3. Integration Tests (API)
```javascript
// api.test.js
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../app';

describe('GET /api/resource', () => {
  it('should return 200 for authenticated user', async () => {
    const res = await request(app)
      .get('/api/resource')
      .set('Authorization', `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('data');
  });

  it('should return 401 for unauthenticated user', async () => {
    const res = await request(app).get('/api/resource');
    expect(res.status).toBe(401);
  });
});
```

### 4. E2E Tests (Playwright)
```javascript
// flow.spec.js
import { test, expect } from '@playwright/test';

test.describe('User Flow', () => {
  test('complete user journey', async ({ page }) => {
    // Navigate
    await page.goto('/');

    // Login
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'password');
    await page.click('[data-testid="submit"]');

    // Verify
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome"]')).toBeVisible();
  });
});
```

### 5. הרצה ואימות
```bash
# Unit + Integration
npm test

# E2E
npm run test:e2e

# Coverage report
npm run test:coverage
```

### 6. סיכום
```markdown
## Test Summary
- Unit tests: X tests, Y files
- Integration tests: X tests
- E2E tests: X scenarios
- Coverage: XX%

## פקודות הרצה
npm test           # כל הtests
npm test:unit      # רק unit
npm test:e2e       # רק e2e
```

---

**Output**: Test suite מלא עם פקודות הרצה
