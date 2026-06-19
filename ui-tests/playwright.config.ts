import { defineConfig, devices } from '@playwright/test';

// SUT location is env-driven so the suite is environment-agnostic.
const baseURL = process.env.UI_BASE_URL ?? 'http://localhost:8000';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  // Retries absorb genuine async flakiness; the resilience demos assert
  // determinism explicitly rather than relying on this.
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: [
    ['list'],
    ['allure-playwright', { resultsDir: 'allure-results' }],
    ['html', { open: 'never' }],
  ],
  use: {
    baseURL,
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
});
