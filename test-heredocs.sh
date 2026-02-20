#!/usr/bin/env bash
set -euo pipefail

DB_MODE=postgres
DB_DIR=/tmp/test-dbdir
SLUG_SAFE=demo
DB_NET=demo_net
DB_USER=user
DB_PASS=pass
DB_NAME=testdb
PGADMIN_EMAIL=you@example.com
PGADMIN_PASSWORD=secret
PGADMIN_HOST=pgadmin.example.com

# ============================================
# DB stack only if DB_MODE != none
# ============================================
if [ "${DB_MODE}" != "none" ]; then
  echo "DB enabled"
  mkdir -p "${DB_DIR}"

  cat > "${DB_DIR}/.env" <<DB_ENV
POSTGRES_USER=${DB_USER}
POSTGRES_PASSWORD=${DB_PASS}
POSTGRES_DB=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASS}
DB_NAME=${DB_NAME}
PGADMIN_DEFAULT_EMAIL=${PGADMIN_EMAIL}
PGADMIN_DEFAULT_PASSWORD=${PGADMIN_PASSWORD}
PGADMIN_DEFAULT_SERVER_NAME=PgBouncer (${SLUG_SAFE})
DB_ENV

  cat > "${DB_DIR}/pgadmin-servers.json" <<DB_SERVERS
{
  "Servers": {
    "1": {
      "Name": "PgBouncer (${SLUG_SAFE})",
      "Group": "Servers",
      "Host": "pgbouncer",
      "Port": 5432,
      "MaintenanceDB": "${DB_NAME}",
      "Username": "${DB_USER}",
      "SSLMode": "prefer"
    }
  }
}
DB_SERVERS

  cat > "${DB_DIR}/docker-compose.yml" <<DB_STACK_YML
services:
  postgres:
    image: postgres:15
DB_STACK_YML

else
  echo "DB disabled"
fi

