-- fierymud-rs #150: a potion / scroll with the same spell in several slots fired it once.
--
-- Legacy potions and scrolls carry up to three spell slots and the same spell may fill more than one
-- (a "small healing potion" is CURE_LIGHT twice, a "dark potion" CURE_CRITIC three times).
-- "ObjectAbilities" had a unique (object, ability) key, so the importer kept only the first copy.
-- The game already fires every binding row in order; the key was the only thing in the way.
--
-- This patch:
--   * drops the unique index (Prisma now declares a plain index on (object_zone_id, object_id));
--   * rebuilds the bindings, in slot order, of each POTION / SCROLL whose "Spells" list repeats a
--     spell and whose bound row count differs from the slot count. Objects that already have the
--     right number of rows are left alone, so a rerun changes nothing.
--
-- Idempotent.

BEGIN;

DROP INDEX IF EXISTS "ObjectAbilities_object_zone_id_object_id_ability_id_key";
CREATE INDEX IF NOT EXISTS "ObjectAbilities_object_zone_id_object_id_idx"
    ON "ObjectAbilities" ("object_zone_id", "object_id");

CREATE TEMP TABLE _batch149_slots ON COMMIT DROP AS
SELECT o.zone_id AS zone_id,
       o.id AS object_id,
       COALESCE((o.values->>'Level')::int, 1) AS level,
       s.ord AS ord,
       a.id AS ability_id
FROM "Objects" o
CROSS JOIN LATERAL jsonb_array_elements_text(o.values->'Spells') WITH ORDINALITY AS s(name, ord)
JOIN "Ability" a ON a.plain_name = s.name
WHERE o.type IN ('POTION', 'SCROLL')
  AND jsonb_typeof(o.values->'Spells') = 'array';

CREATE TEMP TABLE _batch149_fix ON COMMIT DROP AS
SELECT d.zone_id, d.object_id
FROM (
    SELECT zone_id, object_id, count(*) AS slots, count(DISTINCT ability_id) AS spells
    FROM _batch149_slots
    GROUP BY zone_id, object_id
) d
WHERE d.slots > d.spells
  AND d.slots <> (
      SELECT count(*) FROM "ObjectAbilities" oa
      WHERE oa.object_zone_id = d.zone_id AND oa.object_id = d.object_id
  );

DELETE FROM "ObjectAbilities" oa
USING _batch149_fix f
WHERE oa.object_zone_id = f.zone_id AND oa.object_id = f.object_id;

INSERT INTO "ObjectAbilities" ("ability_id", "level", "object_zone_id", "object_id", "charges")
SELECT s.ability_id, s.level, s.zone_id, s.object_id, NULL
FROM _batch149_slots s
JOIN _batch149_fix f ON f.zone_id = s.zone_id AND f.object_id = s.object_id
ORDER BY s.zone_id, s.object_id, s.ord;

COMMIT;
