# API suite (Python + pytest)

Exercises the SUT's REST API (the contract layer). The wide base of the test
pyramid — fast, deterministic, runs on every push.

## Run

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# Point at a running SUT (defaults shown)
export SUT_BASE_URL=http://localhost:9000
export MEDUSA_PUBLISHABLE_KEY=pk_...   # printed by the SUT seed step

pytest                 # all tests, Allure results -> allure-results/
pytest -m smoke        # gate only
pytest -n auto         # parallel (pytest-xdist)
```

## Layout

- `conftest.py` — env-driven fixtures (base URL, publishable key, HTTP session)
- `tests/` — one module per domain area
- `tests/resilience/` *(v2)* — `@pytest.mark.resilience` fault-injection demos
