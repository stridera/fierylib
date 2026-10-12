-- Staff-only socials (data-over-code).
--
-- fierymud-rs kept STAFF_ONLY_SOCIALS = ["snowball"] as a hard-coded list: legacy gave that
-- do_action row a staff level, so players cannot reach it by typing an abbreviation (typed in
-- full it behaves as before). The flag now lives in "Social".staff_only (Muditor socials editor,
-- CODER+ like every social edit); the game falls back to the same list when the column is missing.
--
-- This patch:
--   * adds "Social".staff_only (additive; DDL matches Prisma's `staffOnly Boolean
--     @default(false) @map("staff_only")`, so `prisma db push` is then a no-op);
--   * flags snowball.
--
-- Idempotent and one-way: only rows still false are touched, so a rerun changes 0 rows. The
-- NOTICE line reports the rows flagged (0 on a rerun). Mirrored by SocialsSeeder.mark_staff_only
-- (a unit test keeps the two in sync).

BEGIN;

ALTER TABLE "Social" ADD COLUMN IF NOT EXISTS staff_only BOOLEAN NOT NULL DEFAULT false;

DO $$
DECLARE
  n_flagged integer;
BEGIN
  UPDATE "Social"
  SET staff_only = true, updated_at = now()
  WHERE name IN ('snowball') AND staff_only = false;
  GET DIAGNOSTICS n_flagged = ROW_COUNT;
  RAISE NOTICE 'social-staff-only patch: Social rows flagged staff_only: %', n_flagged;
END $$;

COMMIT;
