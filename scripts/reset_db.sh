#!/usr/bin/env bash
set -euo pipefail

# Simple DB reset helper for FieryLib (Poetry environment)
# Usage:
#   bash scripts/reset_db.sh [--skip-generate] [--seed]
#
# Notes:
# - Runs Prisma via Poetry environment so Python generator is available
# - Falls back automatically if generators fail during reset

SKIP_GEN=0
SEED=0

for arg in "$@"; do
  case "$arg" in
    --skip-generate)
      SKIP_GEN=1
      shift
      ;;
    --seed)
      SEED=1
      shift
      ;;
  esac
done

echo "[1/3] Resetting database..."
if [[ "$SKIP_GEN" -eq 1 ]]; then
  poetry run prisma migrate reset --force --skip-generate || true
else
  if ! poetry run prisma migrate reset --force; then
    echo "Falling back to --skip-generate + db push + generate..."
    poetry run prisma migrate reset --force --skip-generate || true
  fi
fi

echo "[2/3] Ensuring schema is applied..."
poetry run prisma db push

echo "[3/3] Generating Prisma clients (Python + JS)..."
poetry run prisma generate

echo "✅ Database reset complete."

if [[ "$SEED" -eq 1 ]]; then
  echo "Seeding users..."
  poetry run fierylib seed users --reset
fi
