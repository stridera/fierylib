-- BRIBE minimum coin value (legacy bribe_mtrigger: GET_TRIG_NARG(t) is the minimum raw copper).
--
-- Legacy fires only the FIRST BRIBE trigger (attach order) whose numeric argument is <= the
-- coins given. The converter put the minimum inside the Lua body for some scripts and dropped it
-- for others (103/15, 580/4), and num_args was 0 on every BRIBE row, so the engine could not pick
-- the right trigger. fierymud-rs now reads "Triggers".num_args as the minimum copper; the same
-- value is the `-- Num arg:` header line of each data/triggers/*.lua (TriggerImporter reads it).
--
--   0/11 25 | 18/60 100 | 103/15 100000 | 188/84 100 | 324/13 42 | 324/14 30 | 580/4 100000
--
-- Rows with legacy narg 1 (30/161,166,171,183, 61/20, 324/2, 586/3) need no value: every bribe
-- is at least 1 copper. Idempotent: only rows still at 0 are touched, so a rerun changes 0 rows.

BEGIN;

DO $$
DECLARE
  n_set integer;
BEGIN
  UPDATE "Triggers" t
  SET num_args = v.min_copper, updated_at = now()
  FROM (VALUES
    (0, 11, 25),
    (18, 60, 100),
    (103, 15, 100000),
    (188, 84, 100),
    (324, 13, 42),
    (324, 14, 30),
    (580, 4, 100000)
  ) AS v(zone_id, id, min_copper)
  WHERE t.zone_id = v.zone_id
    AND t.id = v.id
    AND 'BRIBE' = ANY (t.flags::text[])
    AND t.num_args = 0;
  GET DIAGNOSTICS n_set = ROW_COUNT;
  RAISE NOTICE 'BRIBE minimums set: % rows (0 on a rerun)', n_set;
END $$;

COMMIT;
