.PHONY: sut sut-down test-api test-ui test

## Bring up the self-hosted SUT (Postgres + Medusa backend + storefront)
sut:
	bash sut/up.sh

## Tear the SUT down
sut-down:
	bash sut/down.sh

## Run the Python/pytest API suite against the running SUT
test-api:
	cd api-tests && python3 -m venv .venv && . .venv/bin/activate && \
	  pip install -q -r requirements.txt && \
	  set -a && . ../sut/.sut-env && set +a && pytest

## Run the TypeScript/Playwright UI suite against the running SUT
test-ui:
	cd ui-tests && npm install && npx playwright install chromium && \
	  set -a && . ../sut/.sut-env && set +a && npx playwright test

## Run both suites
test: test-api test-ui
