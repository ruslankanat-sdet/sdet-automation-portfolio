# SDET Portfolio — Reliable, Polyglot Test Automation

[![tests](https://img.shields.io/badge/tests-CI-blue)](.github/workflows/ci.yml)
[![allure report](https://img.shields.io/badge/report-Allure-purple)](#reporting)

A single, deep test-automation project that demonstrates **lead-level SDET craft**:
rigorous, reliable, well-architected automation — not a pile of shallow demos.

It tests a **self-hosted e-commerce application** (the *System Under Test*) end to
end, in two languages by deliberate design, with controlled fault injection to prove
the suites stay deterministic under stress.

## Why it's built this way

| Decision | Choice | Why |
|---|---|---|
| Strategy | One deep project | A lead is judged on architecture + strategy, not repo count |
| System Under Test | Self-hosted MedusaJS (Docker) | Owned + version-pinned → no external flakiness; real REST API **and** real storefront |
| API suite | Python + pytest | Wide, fast pyramid base; strongest language |
| UI suite | TypeScript + Playwright | A few deep journeys; the in-demand UI skill |
| Resilience | Controlled fault injection | Proves flakiness *handling* on faults I own — the only way to demonstrate it honestly (see [ADR-0001](docs/adr/0001-polyglot-test-architecture.md)) |
| Reporting | Allure (unified) | One report spans both languages — makes the polyglot seam legible |
| CI | GitHub Actions | The tests visibly run green; a reviewer doesn't take my word for it |

The two-language split is documented as a real architectural decision in
[docs/adr/](docs/adr/); the project's vocabulary lives in [CONTEXT.md](CONTEXT.md).

## Architecture

```
                ┌─────────────── GitHub Actions ───────────────┐
                │  docker compose up SUT  →  seed  →  run both  │
                │            suites  →  unified Allure          │
                └───────────────────────────────────────────────┘
   api-tests/ (pytest)  ─┐                              ┌─ ui-tests/ (Playwright)
   REST contract layer   ├──►  SUT: MedusaJS  ◄─────────┤  storefront journeys
   :9009 /store, /admin  ┘     :9009 API  :8000 store   └─ + fault-injection demos
```

## Repo layout

```
sut/         self-hosted MedusaJS SUT (docker-compose, seed) — third-party, not my code
api-tests/   Python + pytest — REST API / contract suite
ui-tests/    TypeScript + Playwright — storefront journeys
docs/adr/    architecture decision records
CONTEXT.md   project glossary
.github/     CI pipeline
```

## Quick start

```bash
make sut       # stand up the SUT (Postgres + Medusa backend :9009 + storefront :8000), seed data
make test      # run both suites against it (API + UI)

# or individually — after `make sut`:
make test-api  # Python + pytest
make test-ui   # TypeScript + Playwright
```

Requires Docker, Node 22+, and Python 3.12+. The SUT picks non-default host ports
(`9009`, `5442`) so it never collides with whatever else you're running.

## Reporting

Both suites emit Allure results; CI merges them into one report published to GitHub
Pages. Locally: `npm run report` (UI) or `allure serve api-tests/allure-results`.

## Roadmap

- **v1 (shareable):** SUT in Docker · health + product API checks · storefront smoke · green CI · unified Allure · this README
- **v2:** full API pyramid (cart, checkout, negatives) · 2–3 deep UI journeys · `@resilience` fault-injection demos
- **v3 (flex):** self-healing locators · optional second SUT (Saleor / GraphQL)
