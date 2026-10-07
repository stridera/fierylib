-- Scroll-of-recall destinations (Refs fierymud-rs #12).
--
-- Brings an already-seeded database in line with `fierylib seed recall-scrolls`
-- without a reimport: sets "Objects"."values"."Recall Rooms" on the four coloured
-- recall scrolls (legacy spec_procs.cpp {red,green,blue,gray}_recall_room).
-- Idempotent: the jsonb || replaces just that one key; rerunning is a no-op.
-- Generated from data/recall_scrolls.json; a unit test keeps the two in sync.

BEGIN;

-- red scroll of recall (legacy vnum 3056)
UPDATE "Objects"
SET "values" = "values" || '{"Recall Rooms": {"classes": {"anti-paladin": {"id": 80, "zone": 60}, "assassin": {"id": 88, "zone": 60}, "bard": {"id": 93, "zone": 60}, "berserker": {"id": 97, "zone": 557}, "cleric": {"id": 18, "zone": 62}, "cryomancer": {"id": 21, "zone": 62}, "diabolist": {"id": 75, "zone": 60}, "druid": {"id": 22, "zone": 62}, "illusionist": {"id": 34, "zone": 62}, "mercenary": {"id": 70, "zone": 61}, "necromancer": {"id": 23, "zone": 62}, "priest": {"id": 18, "zone": 62}, "pyromancer": {"id": 20, "zone": 62}, "rogue": {"id": 68, "zone": 60}, "sorcerer": {"id": 31, "zone": 62}, "thief": {"id": 68, "zone": 60}}, "default": {"id": 49, "zone": 61}}}'::jsonb, updated_at = now()
WHERE zone_id = 30 AND id = 56 AND type = 'SCROLL';

-- green scroll of recall (legacy vnum 3057)
UPDATE "Objects"
SET "values" = "values" || '{"Recall Rooms": {"classes": {"anti-paladin": {"id": 22, "zone": 30}, "assassin": {"id": 38, "zone": 30}, "bard": {"id": 11, "zone": 53}, "berserker": {"id": 212, "zone": 30}, "cleric": {"id": 3, "zone": 30}, "cryomancer": {"id": 93, "zone": 30}, "diabolist": {"id": 3, "zone": 30}, "druid": {"id": 87, "zone": 30}, "illusionist": {"id": 209, "zone": 30}, "mercenary": {"id": 38, "zone": 30}, "monk": {"id": 8, "zone": 53}, "necromancer": {"id": 32, "zone": 169}, "paladin": {"id": 6, "zone": 53}, "priest": {"id": 95, "zone": 30}, "pyromancer": {"id": 94, "zone": 30}, "ranger": {"id": 50, "zone": 35}, "rogue": {"id": 38, "zone": 30}, "sorcerer": {"id": 46, "zone": 30}, "thief": {"id": 38, "zone": 30}}, "default": {"id": 22, "zone": 30}}}'::jsonb, updated_at = now()
WHERE zone_id = 30 AND id = 57 AND type = 'SCROLL';

-- blue scroll of recall (legacy vnum 3058)
UPDATE "Objects"
SET "values" = "values" || '{"Recall Rooms": {"classes": {"assassin": {"id": 48, "zone": 100}, "bard": {"id": 48, "zone": 100}, "berserker": {"id": 42, "zone": 102}, "cleric": {"id": 3, "zone": 100}, "cryomancer": {"id": 30, "zone": 100}, "diabolist": {"id": 3, "zone": 100}, "druid": {"id": 3, "zone": 100}, "illusionist": {"id": 30, "zone": 100}, "mercenary": {"id": 48, "zone": 100}, "necromancer": {"id": 30, "zone": 100}, "priest": {"id": 3, "zone": 100}, "pyromancer": {"id": 30, "zone": 100}, "rogue": {"id": 48, "zone": 100}, "sorcerer": {"id": 30, "zone": 100}, "thief": {"id": 48, "zone": 100}}, "default": {"id": 13, "zone": 100}}}'::jsonb, updated_at = now()
WHERE zone_id = 30 AND id = 58 AND type = 'SCROLL';

-- gray scroll of recall (legacy vnum 30010)
UPDATE "Objects"
SET "values" = "values" || '{"Recall Rooms": {"classes": {"assassin": {"id": 66, "zone": 300}, "bard": {"id": 66, "zone": 300}, "berserker": {"id": 122, "zone": 300}, "cleric": {"id": 70, "zone": 300}, "cryomancer": {"id": 73, "zone": 300}, "diabolist": {"id": 70, "zone": 300}, "druid": {"id": 70, "zone": 300}, "illusionist": {"id": 0, "zone": 300}, "mercenary": {"id": 66, "zone": 300}, "necromancer": {"id": 73, "zone": 300}, "priest": {"id": 70, "zone": 300}, "pyromancer": {"id": 73, "zone": 300}, "rogue": {"id": 66, "zone": 300}, "sorcerer": {"id": 73, "zone": 300}, "thief": {"id": 66, "zone": 300}}, "default": {"id": 30, "zone": 300}}}'::jsonb, updated_at = now()
WHERE zone_id = 300 AND id = 10 AND type = 'SCROLL';

COMMIT;
