-- Familiarity (SPELL) applied the `detect_life` status: an import bug (the converter matched the wrong flag). Legacy
-- (magic.cpp SPELL_FAMILIARITY) sets EFF_FAMILIARITY for `skill / 5 + 4` hours; the engine's `familiarity` status flag sets the
-- Familiar marker (aggressive mobs never start a fight with the bearer), same as Disguise/Statue.
-- Keyed ONLY by Ability.plain_name (ids differ between dev and prod). Guarded on the exact old override_params, so a second run
-- changes 0 rows and builder edits survive.
-- Source of truth for reimports: data/abilities.json.
BEGIN;

UPDATE "AbilityEffect" ae
SET override_params = '{"flag": "familiarity", "duration": "4 + (skill / 5)", "durationUnit": "hours"}'::jsonb
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'FAMILIARITY'
  AND ae.override_params = '{"flag": "detect_life", "duration": "5 + (skill / 10)", "durationUnit": "hours"}'::jsonb;

UPDATE "Ability"
SET description = 'Makes the target look like a familiar friend, so aggressive creatures do not start fights with them.'
WHERE plain_name = 'FAMILIARITY'
  AND description = 'Creates a magical bond that aids in tracking a specific creature.';

COMMIT;
