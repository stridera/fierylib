-- Legacy damage() (fight.cpp:1650-1666) frees a victim from Minor Paralysis / Entangle (legacy casts
-- Entangle as Minor Paralysis) and from Mesmerize when hit. fierymud-rs reads the `breakOnDamage`
-- param of the ability's status effect row for ANY status flag, so the data must say which break:
--   * Entangle  (webbed)     -> breakOnDamage true
--   * Mesmerize              -> flag 'mesmerized' (was 'paralyzed'), breakOnDamage true
--   * Fear family, Confusion -> breakOnDamage false (legacy does not break them on a hit; the Rust
--     runtime only honoured the flag for 'paralyzed' before, so this keeps their behaviour)
-- Source of truth: data/abilities.json (tests/test_break_on_damage.py keeps them in sync).
--
-- Idempotent: every UPDATE is guarded so a second run changes 0 rows.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(COALESCE(ae.override_params, '{}'::jsonb), '{breakOnDamage}', 'true'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'ENTANGLE'
  AND ae.override_params->>'flag' = 'webbed'
  AND COALESCE(ae.override_params->>'breakOnDamage', '') <> 'true';

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
      jsonb_set(ae.override_params, '{flag}', '"mesmerized"'::jsonb),
      '{breakOnDamage}', 'true'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'MESMERIZE'
  AND ae.override_params->>'flag' = 'paralyzed';

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{breakOnDamage}', 'false'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = ANY(ARRAY['FEAR', 'DOOM', 'HYSTERIA', 'TERROR', 'CONFUSION', 'CROWN_OF_MADNESS'])
  AND ae.override_params->>'breakOnDamage' = 'true';
