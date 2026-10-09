-- Camp "fieldcraft" bonus for existing databases (data-over-code).
--
-- A camp earns +1 rest tier when the camper or a group member has a campcraft class (design doc
-- docs/design/rest-and-repose.md: Ranger and Druid). fierymud-rs used to hard-code the class IDs
-- ([9, 7], which are Shaman and Ranger in this database: Druid is 8), so Druids lost the bonus and
-- Shamans got it. It now reads "Class".campcraft_bonus instead:
--   * adds "Class".campcraft_bonus if the column is missing (default false);
--   * sets it by plain_name for Ranger and Druid; every other class stays false.
-- Legacy FieryMUD has no camp tier, so there is no legacy table to import.
--
-- Idempotent: rerunning is a no-op (the UPDATE skips rows already true), and it never turns the flag
-- off, so a builder who clears it on Ranger or Druid keeps that edit only until the first run.

BEGIN;

ALTER TABLE "Class"
    ADD COLUMN IF NOT EXISTS campcraft_bonus boolean NOT NULL DEFAULT false;

UPDATE "Class" AS c
SET campcraft_bonus = true, updated_at = now()
WHERE lower(c.plain_name) IN ('ranger', 'druid')
  AND c.campcraft_bonus IS DISTINCT FROM true;

COMMIT;
