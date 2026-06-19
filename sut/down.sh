#!/usr/bin/env bash
# Tear the SUT down: stop dev servers and Postgres.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Stopping dev servers (backend :9009, storefront :8000)"
pkill -f "medusa develop" 2>/dev/null || true
pkill -f "next dev" 2>/dev/null || true

echo "==> Stopping Postgres"
docker compose -f "$HERE/docker-compose.yml" down

echo "Done."
