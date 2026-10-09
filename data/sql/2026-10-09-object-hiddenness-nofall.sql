-- Object display tags (fierymud-rs): legacy ITEM_NOFALL ("Doesn't fall - unaffected by
-- gravity", shown as "(hovering)") had no home. The importer folded it into FLOAT, which is
-- legacy ITEM_FLOAT (floats in water) and indistinguishable from it afterwards. It is now its own
-- ObjectFlag, NO_FALL.
--
-- Legacy object hiddenness (the `H` section, GET_OBJ_HIDDENNESS) needs no change: it is already
-- imported into "Objects".concealment.
--
-- 1. Add the enum value. ALTER TYPE ... ADD VALUE cannot run inside a transaction block (and
--    the new value cannot be used until it commits), so this file has no BEGIN/COMMIT; run it
--    with psql in autocommit mode. IF NOT EXISTS makes it idempotent.
-- 2. Tag the 79 objects whose legacy flags carry NO_FALL (most of them also carry FLOAT,
--    which is left alone). Keyed by (zone_id, id); a row that already has NO_FALL is
--    skipped, so a second run changes nothing.
--
-- Apply: psql -v ON_ERROR_STOP=1 -U strider -d fierydev -f 2026-10-09-object-hiddenness-nofall.sql
-- Apply this BEFORE deploying a fierymud-rs build that knows NO_FALL, and restart fierymud-rs
-- afterwards (sqlx prepared-statement cache).

ALTER TYPE "ObjectFlag" ADD VALUE IF NOT EXISTS 'NO_FALL';

UPDATE "Objects" o
SET flags = array_append(COALESCE(o.flags, ARRAY[]::"ObjectFlag"[]), 'NO_FALL'::"ObjectFlag")
FROM (VALUES
  (2, 107),
  (2, 108),
  (2, 109),
  (4, 6),
  (4, 7),
  (4, 11),
  (4, 22),
  (4, 24),
  (4, 28),
  (4, 38),
  (4, 39),
  (4, 40),
  (4, 68),
  (4, 71),
  (4, 96),
  (4, 100),
  (4, 108),
  (4, 118),
  (4, 137),
  (4, 143),
  (4, 144),
  (4, 152),
  (6, 55),
  (12, 5),
  (12, 60),
  (12, 70),
  (12, 95),
  (15, 2),
  (15, 4),
  (15, 7),
  (22, 11),
  (22, 75),
  (23, 27),
  (23, 30),
  (23, 31),
  (23, 32),
  (23, 33),
  (43, 19),
  (43, 95),
  (52, 11),
  (52, 12),
  (55, 53),
  (55, 54),
  (83, 1),
  (117, 99),
  (123, 1),
  (123, 38),
  (123, 41),
  (123, 99),
  (133, 22),
  (160, 6),
  (162, 8),
  (173, 8),
  (238, 18),
  (238, 22),
  (360, 11),
  (360, 12),
  (411, 3),
  (430, 21),
  (470, 4),
  (470, 18),
  (489, 17),
  (490, 17),
  (510, 73),
  (520, 2),
  (520, 19),
  (534, 53),
  (534, 54),
  (534, 55),
  (534, 56),
  (534, 57),
  (584, 26),
  (584, 36),
  (615, 17),
  (1000, 33),
  (1000, 42),
  (1000, 67),
  (1000, 72),
  (1000, 74)
) AS legacy(zone_id, id)
WHERE o.zone_id = legacy.zone_id
  AND o.id = legacy.id
  AND NOT ('NO_FALL'::"ObjectFlag" = ANY (COALESCE(o.flags, ARRAY[]::"ObjectFlag"[])));
