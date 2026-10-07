-- Banish tuning (legacy spell_banish, spells.cpp), read by the game from the
-- `extract` effect params (data over code):
--   success_threshold      the banish lands when
--                          random(0,100) + skill + cha_bonus - victim_level
--                          is strictly above this (legacy: 100)
--   gear_destroy_threshold a banished mob's gear is destroyed, otherwise it
--                          drops to the floor, when
--                          random(0,100) + wis_bonus * gear_wis_multiplier
--                          is strictly above this (legacy: 66)
--   gear_wis_multiplier    legacy: 2
--
-- Idempotent: merges the keys into the params without overriding a value a
-- builder has already tuned, so rerunning is a no-op.

BEGIN;

UPDATE "AbilityEffect" ae
SET override_params =
      '{"success_threshold": 100, "gear_destroy_threshold": 66, "gear_wis_multiplier": 2}'::jsonb
      || COALESCE(ae.override_params, '{}'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'BANISH'
  AND e."effectType" = 'extract';

COMMIT;
