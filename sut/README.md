# System Under Test — MedusaJS

> ⚠️ **This directory is third-party, not my work.** My showcased work is in
> [`../api-tests/`](../api-tests) and [`../ui-tests/`](../ui-tests). The SUT exists
> only to give those suites a realistic, *owned*, version-pinned target so the tests
> never depend on an external party's uptime or changes.

MedusaJS v2 (2.15.5) — a real e-commerce backend (REST `/store` + `/admin` API)
plus the Next.js starter storefront. Host ports are remapped to avoid collisions:

| Service | Host port | Note |
|---|---|---|
| Backend API + admin | `9009` | Medusa defaults to 9000; remapped (admin UI at `/app`) |
| Storefront | `8000` | |
| Postgres | `5442` | dodges any native Postgres on 5432 |

## How it was generated

Source-only scaffold (no DB needed at generation time — the DB is provisioned at
bring-up), then vendored so the SUT is reproducible offline:

```bash
npx create-medusa-app@latest medusa \
  --directory-path ./sut --skip-db --no-browser --with-nextjs-starter --use-npm
```

It's a Turborepo monorepo: `sut/medusa/apps/backend` (Medusa) and
`sut/medusa/apps/storefront` (Next.js). Build/install/env artifacts are gitignored.

## Run

```bash
make sut        # from repo root: Postgres (Docker) -> install -> migrate+seed -> start servers
make sut-down   # stop everything
```

`up.sh` is idempotent and self-wiring: every bring-up regenerates the backend/storefront
env and re-extracts the freshly-seeded **publishable API key** into `sut/.sut-env`
(exported to the suites as `MEDUSA_PUBLISHABLE_KEY`). The seed (a Medusa migration
script) creates demo regions, products, inventory, and the publishable key.

## Ports & env

See [`.env.example`](.env.example) and [`docker-compose.yml`](docker-compose.yml).
