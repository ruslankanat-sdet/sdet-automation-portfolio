# Polyglot test architecture: Python for the API suite, TypeScript for the UI suite

## Status

accepted

## Context

The portfolio targets senior/lead SDET roles and must prove competence in two stacks
the author cares about: Python + pytest (their strongest) and Playwright + TypeScript
(the in-demand skill they want to showcase). A single-language repo would be more
coherent and cheaper to maintain, but would only prove one stack.

## Decision

The API suite is written in **Python + pytest** (REST/contract layer) and the UI
suite in **TypeScript + Playwright** (storefront). The two are deliberately separated
along the API-vs-UI boundary, and unified by a single CI pipeline and a single
aggregated test report. The seam is intentional and documented — not two unrelated
folders bolted together.

## Consequences

- We accept the cost of two toolchains, two dependency sets, and a CI pipeline that
  must orchestrate both and merge their reports — because a *clean* two-language seam
  is itself the lead-level signal (deliberate architecture), whereas a sloppy one
  reads worse than a flawless single-language repo.
- Unified reporting (e.g. Allure aggregating both suites) is therefore a hard
  requirement, not a nice-to-have — it is what makes the seam legible to a reviewer.
