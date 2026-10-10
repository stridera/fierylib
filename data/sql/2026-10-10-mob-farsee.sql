-- Legacy EFF_FARSEE is its own effect flag ("farsee"), not detect hidden (fierymud-rs #35: the runtime now
-- lengthens `scan` and `look <dir>` for it). MOB_EFFECT_FLAG_TO_STATUS_FLAG used to map it to "detect_hidden",
-- so every mob / worn object whose legacy EFF_FARSEE was imported carries "detect_hidden" in its status row.
--
-- This rewrites that flag to "farsee" on exactly the rows the old mapping produced, keyed by (zone_id, id):
--   * 20 "MobDefaultEffects" rows (the mobs with EFF_FARSEE in lib/world/mob/*.mob)
--   * 39 "ObjectEffects" rows (objects with EFF_FARSEE in lib/world/obj/*.obj; same mapping table)
-- The rest of each row's flags are kept (array re-sorted, deduplicated). A "detect_hidden" a builder added
-- to any other mob / object is untouched.
--
-- Idempotent: a row is only updated while it still carries "detect_hidden", so a second run changes 0 rows
-- and a builder who has since removed or re-added flags is not overwritten again.
-- Mobs / objects missing from the tables are skipped by the join.

BEGIN;

UPDATE "MobDefaultEffects" d
SET modifier_data = jsonb_set(
    d.modifier_data,
    '{flags}',
    (SELECT COALESCE(jsonb_agg(x ORDER BY x), '[]'::jsonb)
       FROM (SELECT DISTINCT CASE WHEN t.f = 'detect_hidden' THEN 'farsee' ELSE t.f END AS x
               FROM jsonb_array_elements_text(d.modifier_data->'flags') AS t(f)) s)
)
FROM "Effect" e
WHERE e.id = d.effect_id
  AND e.name = 'status'
  AND (d.mob_zone_id, d.mob_id) IN (VALUES
    (10, 8),
    (10, 13),
    (10, 15),
    (10, 18),
    (12, 60),
    (12, 63),
    (22, 0),
    (22, 1),
    (22, 50),
    (22, 51),
    (22, 52),
    (22, 53),
    (22, 54),
    (22, 55),
    (188, 36),
    (188, 42),
    (188, 90),
    (188, 91),
    (490, 3),
    (530, 24)
  )
  AND d.modifier_data->'flags' ? 'detect_hidden';

UPDATE "ObjectEffects" d
SET modifier_data = jsonb_set(
    d.modifier_data,
    '{flags}',
    (SELECT COALESCE(jsonb_agg(x ORDER BY x), '[]'::jsonb)
       FROM (SELECT DISTINCT CASE WHEN t.f = 'detect_hidden' THEN 'farsee' ELSE t.f END AS x
               FROM jsonb_array_elements_text(d.modifier_data->'flags') AS t(f)) s)
)
FROM "Effect" e
WHERE e.id = d.effect_id
  AND e.name = 'status'
  AND (d.object_zone_id, d.object_id) IN (VALUES
    (2, 174),
    (2, 175),
    (2, 176),
    (2, 177),
    (2, 178),
    (2, 179),
    (2, 195),
    (2, 196),
    (2, 197),
    (2, 198),
    (2, 199),
    (4, 2),
    (4, 37),
    (4, 63),
    (4, 73),
    (4, 75),
    (4, 76),
    (4, 77),
    (4, 117),
    (4, 165),
    (4, 169),
    (4, 179),
    (4, 194),
    (9, 8),
    (30, 178),
    (64, 3),
    (64, 23),
    (123, 104),
    (123, 111),
    (123, 117),
    (123, 125),
    (123, 129),
    (123, 143),
    (125, 50),
    (238, 88),
    (492, 52),
    (530, 27),
    (586, 1),
    (625, 51)
  )
  AND d.modifier_data->'flags' ? 'detect_hidden';

COMMIT;
