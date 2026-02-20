#!/usr/bin/env bash
set -euo pipefail

DB_DIR=/tmp/test-db-env
mkdir -p "$DB_DIR"

DB_USER="demo_user"
DB_PASS="demo_pass"
DB_NAME="demo_db"
PGADMIN_EMAIL="you@example.com"
PGADMIN_PASSWORD="secret"
SLUG_SAFE="demo-slug"

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

echo "Wrote ${DB_DIR}/.env:"
cat "${DB_DIR}/.env"
