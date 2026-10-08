-- Holy Word class bonus. Legacy magic.cpp mag_damage():
--   case SPELL_HOLY_WORD: ... if (GET_CLASS(ch) == CLASS_PRIEST || GET_CLASS(ch) == CLASS_PALADIN) dam *= 1.25;
-- Expressed as data: the damage runtime honours a `casterClassMultiplier` map in the AbilityEffect
-- params (keys are lowercase Class.plain_name; the caster's parent classes count too). Source of
-- truth for reimports: data/abilities.json (HOLY_WORD damage effect params).
--
-- Idempotent: only touches the damage row while it has no casterClassMultiplier key, so a second run
-- updates 0 rows and later builder edits to the map survive.
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
    || '{"casterClassMultiplier": {"priest": 1.25, "paladin": 1.25}}'::jsonb
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'HOLY_WORD'
  AND e.name = 'damage'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'casterClassMultiplier');
