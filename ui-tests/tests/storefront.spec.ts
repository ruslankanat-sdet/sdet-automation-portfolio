import { test, expect } from '@playwright/test';

// v1 smoke: the storefront is reachable and the store page renders seeded products.
// v2 layers the deep journeys: (1) browse -> add to cart -> checkout as guest,
// (2) register/login -> purchase.
//
// We hit `/store` (region-prefixed by the storefront middleware, e.g. /dk/store)
// because the starter's homepage is a hero layout — products live on the store page.
test('store page renders seeded products', async ({ page }) => {
  await page.goto('/store');
  await expect(page).toHaveTitle(/store|medusa/i);

  // The starter links each product card to <region>/products/<handle>.
  const productLinks = page.locator('a[href*="/products/"]');
  await expect(productLinks.first()).toBeVisible();
  expect(await productLinks.count()).toBeGreaterThan(0);
});
