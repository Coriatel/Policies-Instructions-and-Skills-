import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('should display login page', async ({ page }) => {
    await page.goto('/login');
    await expect(page.getByRole('heading', { name: /התחברות/i })).toBeVisible();
    await expect(page.getByLabel(/אימייל/i)).toBeVisible();
    await expect(page.getByLabel(/סיסמה/i)).toBeVisible();
  });

  test('should navigate to register page', async ({ page }) => {
    await page.goto('/login');
    await page.getByRole('link', { name: /הירשם כאן/i }).click();
    await expect(page).toHaveURL('/register');
    await expect(page.getByRole('heading', { name: /הרשמה/i })).toBeVisible();
  });

  test('should login with valid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel(/אימייל/i).fill('admin@crm.local');
    await page.getByLabel(/סיסמה/i).fill('Admin123!');
    await page.getByRole('button', { name: /כניסה/i }).click();

    await expect(page).toHaveURL('/dashboard');
  });

  test('should show error on invalid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel(/אימייל/i).fill('wrong@email.com');
    await page.getByLabel(/סיסמה/i).fill('WrongPassword');
    await page.getByRole('button', { name: /כניסה/i }).click();

    await expect(page.getByText(/Invalid credentials/i)).toBeVisible();
  });
});
