-- Import-time flag mismatches between abilities and the status they apply (audit 2026-10-12, after Familiarity applied
-- `detect_life`). Each fix is checked against legacy fierymud_legacy/src/magic.cpp and spells.cpp. Keyed ONLY by
-- Ability.plain_name (ids differ between dev and prod) and guarded on the exact old override_params, so a second run
-- changes 0 rows and builder edits survive. Source of truth for reimports: data/abilities.json.
--
--   DARK_PRESENCE   flag bless is right (legacy sets EFF_BLESS); duration was copied from the wrong spell.
--                   Legacy: 10 + skill / 7 hours (same as Bless), was 5 + skill / 20.
--   PRESERVE        legacy spell_preserve is a MANUAL spell that only adds the caster's level in hours to a corpse's
--                   decay timer. It never touches the caster. Drop the stray `sanctuary` status; the alter_object
--                   `corpse_timer` row (order 1) already does the real work.
--   DIVINE_ESSENCE  legacy perform_mag_group casts Greater Endurance + Bless on every group member, not Sanctuary.
--                   Status becomes bless (10 + skill / 7 hours), plus the Greater Endurance modify row.
--
-- NOT fixed here (the engine lacks the behaviour): Misdirection, Nimble, Ventriloquate, see
-- ops/notes/ability-flag-gaps-2026-10-12.md.
BEGIN;

UPDATE "AbilityEffect" ae
SET override_params = '{"flag": "bless", "duration": "10 + (skill / 7)", "durationUnit": "hours"}'::jsonb
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'DARK_PRESENCE'
  AND ae.override_params = '{"flag": "bless", "duration": "5 + (skill / 20)", "durationUnit": "hours"}'::jsonb;

DELETE FROM "AbilityEffect" ae
USING "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'PRESERVE'
  AND ae."order" = 0
  AND ae.override_params = '{"flag": "sanctuary", "duration": "skill / 5", "durationUnit": "hours"}'::jsonb;

WITH fixed AS (
  UPDATE "AbilityEffect" ae
  SET override_params = '{"flag": "bless", "duration": "10 + (skill / 7)", "durationUnit": "hours"}'::jsonb
  FROM "Ability" a
  WHERE a.id = ae.ability_id
    AND a.plain_name = 'DIVINE_ESSENCE'
    AND ae."order" = 0
    AND ae.override_params = '{"flag": "sanctuary", "duration": "5 + (skill / 10)", "durationUnit": "hours"}'::jsonb
  RETURNING ae.ability_id
)
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT f.ability_id,
       (SELECT id FROM "Effect" WHERE name = 'modify'),
       '{"amount": "skill", "target": "max_move", "duration": "skill / 15", "durationUnit": "hours"}'::jsonb,
       1, 'on_cast', 100
FROM fixed f
ON CONFLICT DO NOTHING;

COMMIT;
