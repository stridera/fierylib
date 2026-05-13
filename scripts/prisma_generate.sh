#!/usr/bin/env bash
# Generate Python Prisma client from the shared schema.
#
# The prisma-client-py (v5.x, archived) requires `url` in the datasource block,
# but Prisma 7 (used by Muditor JS) forbids it. This script patches a temp copy
# of the schema to add the URL, generates the Python client, then cleans up.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIERYLIB_DIR="$(dirname "$SCRIPT_DIR")"
SCHEMA_PATH="${PRISMA_SCHEMA_PATH:-../muditor/packages/db/prisma/schema.prisma}"

# Resolve relative to fierylib root
cd "$FIERYLIB_DIR"
SCHEMA_ABS="$(realpath "$SCHEMA_PATH")"

if [[ ! -f "$SCHEMA_ABS" ]]; then
  echo "❌ Schema not found: $SCHEMA_ABS"
  exit 1
fi

# Create a temp copy with the URL added to the datasource block
TEMP_SCHEMA="$(mktemp --suffix=.prisma)"
trap 'rm -f "$TEMP_SCHEMA"' EXIT

sed 's/datasource db {/datasource db {\n  url      = env("DATABASE_URL")/' "$SCHEMA_ABS" > "$TEMP_SCHEMA"

echo "Generating Python Prisma client from: $SCHEMA_ABS"
poetry run prisma generate --schema "$TEMP_SCHEMA" --generator py
echo "✅ Python Prisma client regenerated"
