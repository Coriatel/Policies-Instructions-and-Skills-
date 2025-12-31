import { test, expect } from '@playwright/test';

test.describe('Content Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await page.goto('/login');
    await page.getByLabel(/אימייל/i).fill('admin@crm.local');
    await page.getByLabel(/סיסמה/i).fill('Admin123!');
    await page.getByRole('button', { name: /כניסה/i }).click();
    await expect(page).toHaveURL('/dashboard');
  });

  test('should display content list', async ({ page }) => {
    await page.goto('/content');
    await expect(page.getByRole('heading', { name: /תכנים/i })).toBeVisible();
  });

  test('should navigate to create content page', async ({ page }) => {
    await page.goto('/content');
    await page.getByRole('link', { name: /יצירת תוכן חדש/i }).click();
    await expect(page).toHaveURL('/content/new');
  });

  test('should create new content', async ({ page }) => {
    await page.goto('/content/new');

    await page.getByLabel(/כותרת/i).fill('Test Content');
    await page.getByLabel(/תיאור/i).fill('Test Description');
    await page.getByLabel(/תוכן/i).fill('This is test content');

    await page.getByRole('button', { name: /יצירה/i }).click();

    await expect(page).toHaveURL('/content');
    await expect(page.getByText('Test Content')).toBeVisible();
  });
});
