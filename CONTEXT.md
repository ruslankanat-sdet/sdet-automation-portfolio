# SDET Portfolio

A single, deep test-automation project whose purpose is to demonstrate lead-level
SDET craft to hiring teams (AV / robotics / e-commerce). Its thesis is *rigorous,
reliable, well-architected automation at scale* — not breadth of shallow examples.

## Language

**System Under Test (SUT)**:
The self-hosted e-commerce application instance the suites exercise, version-pinned
and run locally / in CI (MedusaJS). Owned by us so tests never depend on an external
party's uptime or changes.
_Avoid_: target site, the website, the app under test

**API suite**:
The Python + pytest suite that exercises the SUT's REST API (the contract layer).
_Avoid_: backend tests, integration tests

**UI suite**:
The TypeScript + Playwright suite that exercises the SUT's storefront (the
presentation layer).
_Avoid_: frontend tests, e2e tests (ambiguous — both suites are end-to-end)

**Fault injection**:
A deliberately introduced, controlled failure condition (latency, forced 5xx,
locator/DOM mutation) used to demonstrate that the suites stay deterministic under
stress. Distinct from *uncontrolled flakiness*, which we treat as a defect to
eliminate, not a feature to show.
_Avoid_: chaos (too broad), flakiness (reserved for the defect, not the demo)
