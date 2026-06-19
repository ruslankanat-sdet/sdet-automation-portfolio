#!/usr/bin/env bash
# Bring up the SUT (MedusaJS) reproducibly: Postgres in Docker, backend + storefront
# via npm. Regenerates all env from scratch so a fresh DB seed (which mints a NEW
# publishable key every time) always stays wired correctly. Idempotent-ish: safe to
# re-run; it recreates env and restarts the dev servers.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEDUSA="$HERE/medusa"
BACKEND="$MEDUSA/apps/backend"
STOREFRONT="$MEDUSA/apps/storefront"

BACKEND_PORT="${BACKEND_PORT:-9009}"     # 9000 is Medusa's default; remapped to dodge collisions
STOREFRONT_PORT=8000
REGION="${REGION:-dk}"

echo "==> [1/6] Postgres"
docker compose -f "$HERE/docker-compose.yml" up -d --wait

echo "==> [2/6] Install deps"
( cd "$MEDUSA" && (npm ci || npm install) )

echo "==> [3/6] Backend env"
cat > "$BACKEND/.env" <<EOF
STORE_CORS=http://localhost:${STOREFRONT_PORT}
ADMIN_CORS=http://localhost:${BACKEND_PORT},http://localhost:5173
AUTH_CORS=http://localhost:${BACKEND_PORT},http://localhost:${STOREFRONT_PORT},http://localhost:5173
JWT_SECRET=supersecret
COOKIE_SECRET=supersecret
DATABASE_URL=postgres://medusa:medusa@localhost:5442/medusa
PORT=${BACKEND_PORT}
EOF

echo "==> [4/6] Migrate + seed"
( cd "$BACKEND" && npx medusa db:migrate )

echo "==> [5/6] Wire publishable key into storefront + .sut-env"
PK="$(docker exec sut-postgres psql -U medusa -d medusa -tA \
      -c "SELECT token FROM api_key WHERE type='publishable' LIMIT 1;" | tr -d '[:space:]')"
[ -n "$PK" ] || { echo "ERROR: no publishable key found after seed"; exit 1; }

cat > "$STOREFRONT/.env.local" <<EOF
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=${PK}
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:${BACKEND_PORT}
NEXT_PUBLIC_DEFAULT_REGION=${REGION}
NEXT_PUBLIC_BASE_URL=http://localhost:${STOREFRONT_PORT}
NODE_ENV=development
EOF

cat > "$HERE/.sut-env" <<EOF
SUT_BASE_URL=http://localhost:${BACKEND_PORT}
UI_BASE_URL=http://localhost:${STOREFRONT_PORT}
MEDUSA_PUBLISHABLE_KEY=${PK}
EOF

echo "==> [6/6] Start backend (:${BACKEND_PORT}) + storefront (:${STOREFRONT_PORT})"
( cd "$BACKEND" && nohup npx medusa develop > "$HERE/.backend.log" 2>&1 & )
( cd "$STOREFRONT" && nohup npm run dev > "$HERE/.storefront.log" 2>&1 & )

wait_for() { # url label
  for _ in $(seq 1 90); do curl -fsS -o /dev/null "$1" && { echo "    ready: $2"; return 0; }; sleep 2; done
  echo "ERROR: timed out waiting for $2 ($1)"; return 1
}
echo "==> Waiting for SUT to be ready..."
wait_for "http://localhost:${BACKEND_PORT}/health" "backend API"
wait_for "http://localhost:${STOREFRONT_PORT}/${REGION}/store" "storefront"

echo
echo "SUT is up:"
echo "  API:        http://localhost:${BACKEND_PORT}  (admin /app)"
echo "  Storefront: http://localhost:${STOREFRONT_PORT}"
echo "  Env:        sut/.sut-env  (source it before running the suites)"
