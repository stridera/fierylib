-- CreationRecipe: what the creation spells conjure, moved out of the hard-coded
-- tables in fierymud-rs commands.rs (data over code).
--
--   MINOR_CREATION  one row per keyword (legacy minor_creation_items[] in
--                   constants.cpp; vnum 1000+i = zone 10 id i). The game matches
--                   the typed word as an abbreviation in `id` order, so the rows
--                   are inserted in legacy order.
--   CREATE_FOOD     one row per caster class (legacy spell_creations in
--                   magic.cpp: Priest 100, Paladin 110, Anti-Paladin 130,
--                   Druid 140, everyone else 120). object_id NULL = any FOOD
--                   object in that zone, picked by the caster's skill.
--
-- Keyed by Ability.plain_name / Class.plain_name, so ids may differ per database.
-- Also pins Create Food's fallback object (waybread, zone 185 id 8) in the
-- ability's `create` effect params, used when a class zone has no FOOD loaded.
--
-- Idempotent and builder-safe: the table is created IF NOT EXISTS, a row is
-- inserted only when no row exists for its (ability, keyword, class), and the
-- params merge never overrides a value already set. A second run changes
-- nothing. Keep in sync with the Prisma model CreationRecipe in
-- muditor/packages/db/prisma/schema.prisma. Generated from
-- data/creation_recipes.json; a unit test keeps the two in sync.

BEGIN;

CREATE TABLE IF NOT EXISTS "CreationRecipe" (
    "id" SERIAL NOT NULL,
    "ability_id" INTEGER NOT NULL,
    "keyword" TEXT,
    "class_id" INTEGER,
    "object_zone_id" INTEGER NOT NULL,
    "object_id" INTEGER,

    CONSTRAINT "CreationRecipe_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "CreationRecipe_ability_id_fkey" FOREIGN KEY ("ability_id") REFERENCES "Ability"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "CreationRecipe_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "Class"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "CreationRecipe_ability_id_keyword_class_id_key"
    ON "CreationRecipe"("ability_id", "keyword", "class_id");

INSERT INTO "CreationRecipe" (ability_id, keyword, class_id, object_zone_id, object_id)
SELECT a.id, v.keyword, c.id, v.zone, v.obj
FROM (VALUES
    (1, 'MINOR_CREATION', 'backpack', NULL::text, 10, 0),
    (2, 'MINOR_CREATION', 'sack', NULL::text, 10, 1),
    (3, 'MINOR_CREATION', 'robe', NULL::text, 10, 2),
    (4, 'MINOR_CREATION', 'hood', NULL::text, 10, 3),
    (5, 'MINOR_CREATION', 'lantern', NULL::text, 10, 4),
    (6, 'MINOR_CREATION', 'torch', NULL::text, 10, 5),
    (7, 'MINOR_CREATION', 'waterskin', NULL::text, 10, 6),
    (8, 'MINOR_CREATION', 'barrel', NULL::text, 10, 7),
    (9, 'MINOR_CREATION', 'rations', NULL::text, 10, 8),
    (10, 'MINOR_CREATION', 'raft', NULL::text, 10, 9),
    (11, 'MINOR_CREATION', 'club', NULL::text, 10, 10),
    (12, 'MINOR_CREATION', 'mace', NULL::text, 10, 11),
    (13, 'MINOR_CREATION', 'dagger', NULL::text, 10, 12),
    (14, 'MINOR_CREATION', 'greatsword', NULL::text, 10, 13),
    (15, 'MINOR_CREATION', 'longsword', NULL::text, 10, 14),
    (16, 'MINOR_CREATION', 'staff', NULL::text, 10, 15),
    (17, 'MINOR_CREATION', 'shield', NULL::text, 10, 16),
    (18, 'MINOR_CREATION', 'shortsword', NULL::text, 10, 17),
    (19, 'MINOR_CREATION', 'jacket', NULL::text, 10, 18),
    (20, 'MINOR_CREATION', 'pants', NULL::text, 10, 19),
    (21, 'MINOR_CREATION', 'leggings', NULL::text, 10, 20),
    (22, 'MINOR_CREATION', 'gauntlets', NULL::text, 10, 21),
    (23, 'MINOR_CREATION', 'sleeves', NULL::text, 10, 22),
    (24, 'MINOR_CREATION', 'gloves', NULL::text, 10, 23),
    (25, 'MINOR_CREATION', 'helmet', NULL::text, 10, 24),
    (26, 'MINOR_CREATION', 'skullcap', NULL::text, 10, 25),
    (27, 'MINOR_CREATION', 'boots', NULL::text, 10, 26),
    (28, 'MINOR_CREATION', 'sandals', NULL::text, 10, 27),
    (29, 'MINOR_CREATION', 'cloak', NULL::text, 10, 28),
    (30, 'MINOR_CREATION', 'book', NULL::text, 10, 29),
    (31, 'MINOR_CREATION', 'quill', NULL::text, 10, 30),
    (32, 'MINOR_CREATION', 'belt', NULL::text, 10, 31),
    (33, 'MINOR_CREATION', 'ring', NULL::text, 10, 32),
    (34, 'MINOR_CREATION', 'bracelet', NULL::text, 10, 33),
    (35, 'MINOR_CREATION', 'bottle', NULL::text, 10, 34),
    (36, 'MINOR_CREATION', 'keg', NULL::text, 10, 35),
    (37, 'MINOR_CREATION', 'mask', NULL::text, 10, 36),
    (38, 'MINOR_CREATION', 'earring', NULL::text, 10, 37),
    (39, 'MINOR_CREATION', 'scarf', NULL::text, 10, 38),
    (40, 'MINOR_CREATION', 'bracer', NULL::text, 10, 39),
    (41, 'CREATE_FOOD', NULL::text, 'Priest', 100, NULL::int),
    (42, 'CREATE_FOOD', NULL::text, 'Paladin', 110, NULL::int),
    (43, 'CREATE_FOOD', NULL::text, 'Anti-Paladin', 130, NULL::int),
    (44, 'CREATE_FOOD', NULL::text, 'Druid', 140, NULL::int),
    (45, 'CREATE_FOOD', NULL::text, NULL::text, 120, NULL::int)
) AS v(ord, ability, keyword, class_name, zone, obj)
JOIN "Ability" a ON a.plain_name = v.ability
LEFT JOIN "Class" c ON c.plain_name = v.class_name
WHERE (v.class_name IS NULL OR c.id IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 FROM "CreationRecipe" r
      WHERE r.ability_id = a.id
        AND r.keyword IS NOT DISTINCT FROM v.keyword
        AND r.class_id IS NOT DISTINCT FROM c.id
  )
ORDER BY v.ord;

UPDATE "AbilityEffect" ae
SET override_params =
      '{"objectZoneId": 185, "objectId": 8}'::jsonb || COALESCE(ae.override_params, '{}'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'CREATE_FOOD'
  AND e."effectType" = 'create'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ?& ARRAY['objectZoneId', 'objectId']);

COMMIT;
