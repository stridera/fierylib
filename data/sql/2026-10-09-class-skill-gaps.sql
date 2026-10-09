-- Class skill gap-fill for existing databases (data-over-code).
--
-- fierymud-rs used to gate four skill commands on hard-coded class ids
-- (steal on [3, 10], claw on [8, 9], electrify on [1, 12, 13, 17], summon
-- mount on [5, 6]). It now reads "ClassSkills" (and "KnownAbilities") like
-- every other skill. Checked against the legacy class.cpp skill_assign()
-- calls (data/classes.json "classSkills" is parsed from them):
--
--   STEAL         Thief 10, Bard 10          (no Assassin; the old [3, 10] was wrong)
--   SUMMON_MOUNT  Paladin 15, Anti-Paladin 15
--   CLAW          no class at all: legacy gives it to animal shapechange forms
--   ELECTRIFY     no class at all: legacy gives it to the eel shapechange form
--
-- so CLAW and ELECTRIFY get no rows (inventing class rows would diverge from
-- legacy); they open for a character whose KnownAbilities lists them.
--
-- This patch inserts the STEAL / SUMMON_MOUNT rows where a database lacks
-- them. Rows are keyed by Class.plain_name and Ability.plain_name, never by
-- numeric id (ids differ between dev and prod). An existing row is left
-- untouched, so a builder's later edit of its level or cap survives.
--
-- The seven "immobilizer" names fierymud-rs used to match in is_immobilized
-- (paralysis, web, ...) are not "Effect" rows (that table holds effect
-- *types*: status, stun, knockdown, ...); the runtime now asks
-- Effect.prevents_movement through effect_prevents(), which also covers the
-- status flags (webbed, held, paralyzed, ...), so there is nothing to set.
--
-- Idempotent: ON CONFLICT DO NOTHING on the (class_id, ability_id) unique
-- index, so a second run inserts 0 rows.

BEGIN;

INSERT INTO "ClassSkills" (class_id, ability_id, min_level, proficiency_cap)
SELECT c.id, a.id, v.min_level, 100
FROM (VALUES
        ('Thief',        'STEAL',        10),
        ('Bard',         'STEAL',        10),
        ('Paladin',      'SUMMON_MOUNT', 15),
        ('Anti-Paladin', 'SUMMON_MOUNT', 15)
) AS v(class_plain_name, ability_plain_name, min_level)
JOIN "Class" c ON lower(c.plain_name) = lower(v.class_plain_name)
JOIN "Ability" a ON upper(a.plain_name) = v.ability_plain_name
ON CONFLICT (class_id, ability_id) DO NOTHING;

COMMIT;
