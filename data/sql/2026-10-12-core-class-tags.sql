-- Engine-binding tags on classes (data-over-code).
--
-- fierymud-rs bound the Monk and Thief engine features (monk unarmed combat, thief
-- backstab/steal gating) to classes by DISPLAY NAME, so renaming a class in Muditor silently
-- disabled the feature. It now resolves them from "Class".tags (`core:monk`, `core:thief`) and only
-- falls back to the name (with a WARN) when no row carries the tag. This patch:
--   * adds "Class".tags text[] if the column is missing (Muditor's `prisma db push` also creates it);
--   * appends `core:monk` / `core:thief` to the class whose current name matches, if not present.
--
-- Idempotent: rerunning is a no-op (the UPDATE skips rows that already carry the tag).

BEGIN;

ALTER TABLE "Class"
    ADD COLUMN IF NOT EXISTS tags text[] DEFAULT ARRAY[]::text[];

UPDATE "Class" AS c
SET tags = array_append(coalesce(c.tags, ARRAY[]::text[]), 'core:monk'), updated_at = now()
WHERE lower(c.plain_name) = 'monk'
  AND NOT ('core:monk' = ANY (coalesce(c.tags, ARRAY[]::text[])));

UPDATE "Class" AS c
SET tags = array_append(coalesce(c.tags, ARRAY[]::text[]), 'core:thief'), updated_at = now()
WHERE lower(c.plain_name) = 'thief'
  AND NOT ('core:thief' = ANY (coalesce(c.tags, ARRAY[]::text[])));

COMMIT;
