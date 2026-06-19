# UI suite (TypeScript + Playwright)

Exercises the SUT's storefront. The narrow top of the pyramid — a few critical
user journeys tested as full browser flows, not wide shallow coverage.

## Run

```bash
npm install
npx playwright install --with-deps chromium

export UI_BASE_URL=http://localhost:8000   # storefront (default)
npm test
npm run report                              # Allure report
```

## Journeys

- **v1:** storefront loads and renders seeded products (smoke)
- **v2:** browse → add to cart → checkout (guest); register/login → purchase
- **v2:** `@resilience` — latency injection, forced 5xx + retry, locator mutation
  (the last teed up for future self-healing)
