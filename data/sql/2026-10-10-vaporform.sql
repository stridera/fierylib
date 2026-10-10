-- Vaporform (fierymud-rs #35 follow-up). Legacy magic.cpp SPELL_VAPORFORM sets APPLY_COMPOSITION = COMP_MIST
-- (flesh bodies only) for 2 + skill/25 hours and nothing else: no invisibility. The data said
-- {"flag": "invisible"}, which made the spell a second Invisibility. The flag is now "vaporform"; the runtime
-- (mob_effects::FLAG_MARKERS) sets the actor's composition to mist for its duration and restores it afterwards,
-- the same way Waterform ("waterform") sets water.
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each statement
-- only touches a row still in the old shape, so a second run changes 0 rows and builder edits survive.
-- Source of truth for reimports: data/abilities.json (tests/test_vaporform.py keeps them in sync).

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{flag}', '"vaporform"'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'VAPORFORM'
  AND e.name = 'status'
  AND ae.override_params->>'flag' = 'invisible';

UPDATE "Ability"
SET description = 'Transforms the caster into a misty cloud of vapor.'
WHERE plain_name = 'VAPORFORM'
  AND description = 'Transforms the caster into mist, granting invisibility and ethereal movement.';
