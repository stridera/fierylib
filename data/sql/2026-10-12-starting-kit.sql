-- StartingKit: what a new character is handed in their pack, moved out of
-- legacy give_newbie_eq() (class.cpp) into data (data over code).
--
--   class_id NULL   every class (legacy common_newbie_eq[]: small leather bag,
--                   iron rations, water skin, wooden torch, small map of
--                   Mielikki, quest journal)
--   class_id set    that class only (legacy classes[].newbie_eq[]: the crude
--                   weapon and light armour, or the sorcerer's spellbook, quill,
--                   linen leggings, hood, sandals and dagger)
--
-- Legacy gave no coin, so there is no coin column. Rows are handed out in `id`
-- order. Keyed by Class.plain_name, so ids may differ per database. No FK on the
-- object: a partial world import must not block the seed, and the game logs a
-- missing proto.
--
-- Idempotent and builder-safe: the table is created IF NOT EXISTS and a row is
-- inserted only when no row exists for its (class, object). A second run
-- changes nothing. Keep in sync with the Prisma model StartingKit in
-- muditor/packages/db/prisma/schema.prisma. Generated from
-- data/starting_kit.json; a unit test keeps the two in sync.

BEGIN;

CREATE TABLE IF NOT EXISTS "StartingKit" (
    "id" SERIAL NOT NULL,
    "class_id" INTEGER,
    "object_zone_id" INTEGER NOT NULL,
    "object_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "StartingKit_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "StartingKit_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "Class"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "StartingKit_class_id_object_zone_id_object_id_key"
    ON "StartingKit"("class_id", "object_zone_id", "object_id");

INSERT INTO "StartingKit" (class_id, object_zone_id, object_id, quantity)
SELECT c.id, v.zone, v.obj, v.qty
FROM (VALUES
    (1, NULL::text, 0, 18, 1),
    (2, NULL::text, 0, 19, 1),
    (3, NULL::text, 0, 20, 1),
    (4, NULL::text, 0, 23, 1),
    (5, NULL::text, 30, 90, 1),
    (6, NULL::text, 2, 99, 1),
    (7, 'Sorcerer', 10, 29, 1),
    (8, 'Sorcerer', 11, 54, 1),
    (9, 'Sorcerer', 0, 38, 1),
    (10, 'Sorcerer', 10, 3, 1),
    (11, 'Sorcerer', 10, 27, 1),
    (12, 'Sorcerer', 10, 12, 1),
    (13, 'Cleric', 10, 19, 1),
    (14, 'Cleric', 10, 22, 1),
    (15, 'Cleric', 10, 25, 1),
    (16, 'Cleric', 10, 27, 1),
    (17, 'Cleric', 10, 11, 1),
    (18, 'Thief', 10, 19, 1),
    (19, 'Thief', 10, 22, 1),
    (20, 'Thief', 10, 25, 1),
    (21, 'Thief', 10, 27, 1),
    (22, 'Thief', 10, 12, 1),
    (23, 'Warrior', 10, 19, 1),
    (24, 'Warrior', 10, 22, 1),
    (25, 'Warrior', 10, 24, 1),
    (26, 'Warrior', 10, 26, 1),
    (27, 'Warrior', 10, 14, 1),
    (28, 'Paladin', 10, 19, 1),
    (29, 'Paladin', 10, 22, 1),
    (30, 'Paladin', 10, 24, 1),
    (31, 'Paladin', 10, 26, 1),
    (32, 'Paladin', 10, 14, 1),
    (33, 'Anti-Paladin', 10, 19, 1),
    (34, 'Anti-Paladin', 10, 22, 1),
    (35, 'Anti-Paladin', 10, 24, 1),
    (36, 'Anti-Paladin', 10, 26, 1),
    (37, 'Anti-Paladin', 10, 14, 1),
    (38, 'Ranger', 10, 19, 1),
    (39, 'Ranger', 10, 22, 1),
    (40, 'Ranger', 10, 24, 1),
    (41, 'Ranger', 10, 26, 1),
    (42, 'Ranger', 10, 14, 1),
    (43, 'Druid', 10, 19, 1),
    (44, 'Druid', 10, 22, 1),
    (45, 'Druid', 10, 25, 1),
    (46, 'Druid', 10, 27, 1),
    (47, 'Druid', 10, 11, 1),
    (48, 'Shaman', 10, 19, 1),
    (49, 'Shaman', 10, 22, 1),
    (50, 'Shaman', 10, 25, 1),
    (51, 'Shaman', 10, 27, 1),
    (52, 'Shaman', 10, 11, 1),
    (53, 'Assassin', 10, 19, 1),
    (54, 'Assassin', 10, 22, 1),
    (55, 'Assassin', 10, 25, 1),
    (56, 'Assassin', 10, 27, 1),
    (57, 'Assassin', 10, 12, 1),
    (58, 'Mercenary', 10, 19, 1),
    (59, 'Mercenary', 10, 22, 1),
    (60, 'Mercenary', 10, 24, 1),
    (61, 'Mercenary', 10, 26, 1),
    (62, 'Mercenary', 10, 14, 1),
    (63, 'Necromancer', 10, 29, 1),
    (64, 'Necromancer', 11, 54, 1),
    (65, 'Necromancer', 0, 38, 1),
    (66, 'Necromancer', 10, 3, 1),
    (67, 'Necromancer', 10, 27, 1),
    (68, 'Necromancer', 10, 12, 1),
    (69, 'Conjurer', 10, 29, 1),
    (70, 'Conjurer', 11, 54, 1),
    (71, 'Conjurer', 0, 38, 1),
    (72, 'Conjurer', 10, 3, 1),
    (73, 'Conjurer', 10, 27, 1),
    (74, 'Conjurer', 10, 12, 1),
    (75, 'Monk', 10, 19, 1),
    (76, 'Monk', 10, 22, 1),
    (77, 'Monk', 10, 24, 1),
    (78, 'Monk', 10, 26, 1),
    (79, 'Monk', 10, 14, 1),
    (80, 'Berserker', 10, 19, 1),
    (81, 'Berserker', 10, 22, 1),
    (82, 'Berserker', 10, 24, 1),
    (83, 'Berserker', 10, 26, 1),
    (84, 'Berserker', 10, 14, 1),
    (85, 'Priest', 10, 19, 1),
    (86, 'Priest', 10, 22, 1),
    (87, 'Priest', 10, 25, 1),
    (88, 'Priest', 10, 27, 1),
    (89, 'Priest', 10, 11, 1),
    (90, 'Diabolist', 10, 19, 1),
    (91, 'Diabolist', 10, 22, 1),
    (92, 'Diabolist', 10, 25, 1),
    (93, 'Diabolist', 10, 27, 1),
    (94, 'Diabolist', 10, 11, 1),
    (95, 'Mystic', 10, 19, 1),
    (96, 'Mystic', 10, 22, 1),
    (97, 'Mystic', 10, 25, 1),
    (98, 'Mystic', 10, 27, 1),
    (99, 'Mystic', 10, 11, 1),
    (100, 'Rogue', 10, 19, 1),
    (101, 'Rogue', 10, 22, 1),
    (102, 'Rogue', 10, 25, 1),
    (103, 'Rogue', 10, 27, 1),
    (104, 'Rogue', 10, 12, 1),
    (105, 'Bard', 10, 19, 1),
    (106, 'Bard', 10, 22, 1),
    (107, 'Bard', 10, 25, 1),
    (108, 'Bard', 10, 27, 1),
    (109, 'Bard', 10, 12, 1),
    (110, 'Pyromancer', 10, 29, 1),
    (111, 'Pyromancer', 11, 54, 1),
    (112, 'Pyromancer', 0, 38, 1),
    (113, 'Pyromancer', 10, 3, 1),
    (114, 'Pyromancer', 10, 27, 1),
    (115, 'Pyromancer', 10, 12, 1),
    (116, 'Cryomancer', 10, 29, 1),
    (117, 'Cryomancer', 11, 54, 1),
    (118, 'Cryomancer', 0, 38, 1),
    (119, 'Cryomancer', 10, 3, 1),
    (120, 'Cryomancer', 10, 27, 1),
    (121, 'Cryomancer', 10, 12, 1),
    (122, 'Illusionist', 10, 29, 1),
    (123, 'Illusionist', 11, 54, 1),
    (124, 'Illusionist', 0, 38, 1),
    (125, 'Illusionist', 10, 3, 1),
    (126, 'Illusionist', 10, 27, 1),
    (127, 'Illusionist', 10, 12, 1),
    (128, 'Hunter', 10, 19, 1),
    (129, 'Hunter', 10, 22, 1),
    (130, 'Hunter', 10, 25, 1),
    (131, 'Hunter', 10, 27, 1),
    (132, 'Hunter', 10, 12, 1)
) AS v(ord, class_name, zone, obj, qty)
LEFT JOIN "Class" c ON c.plain_name = v.class_name
WHERE (v.class_name IS NULL OR c.id IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 FROM "StartingKit" k
      WHERE k.class_id IS NOT DISTINCT FROM c.id
        AND k.object_zone_id = v.zone
        AND k.object_id = v.obj
  )
ORDER BY v.ord;

-- Environment-neutral ownership: tables created by a superuser (postgres on prod)
-- must belong to the same role as the existing tables, or Prisma gets
-- "permission denied". Dev owner is strider, prod is fierynext.
DO $$
DECLARE
  tbl_owner text;
  t text;
  seq text;
BEGIN
  SELECT tableowner INTO tbl_owner FROM pg_tables WHERE tablename = 'Characters' LIMIT 1;
  IF tbl_owner IS NOT NULL THEN
    FOREACH t IN ARRAY ARRAY['StartingKit'] LOOP
      EXECUTE format('ALTER TABLE %I OWNER TO %I', t, tbl_owner);
      FOR seq IN
        SELECT sq.relname
        FROM pg_class sq
        JOIN pg_depend d ON d.objid = sq.oid AND d.deptype = 'a'
        JOIN pg_class tb ON tb.oid = d.refobjid
        WHERE sq.relkind = 'S' AND tb.relname = t AND tb.relnamespace = 'public'::regnamespace
      LOOP
        EXECUTE format('ALTER SEQUENCE %I OWNER TO %I', seq, tbl_owner);
      END LOOP;
    END LOOP;
  END IF;
END $$;

COMMIT;
