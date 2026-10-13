-- Endurance / Vitality family (fierymud-rs #149, ahigerd). Legacy magic.cpp mag_affect "Temp HP spells" gives every one of
-- SPELL_LESSER_ENDURANCE / ENDURANCE / GREATER_ENDURANCE / VITALITY / GREATER_VITALITY / DRAGONS_HEALTH one APPLY_HIT
-- affect (MAX HP, never max move), sized by get_vitality_hp_gain() and timed by get_spell_duration():
--
--   spell               hp gain (then -random(2,10))   duration (ticks = "hours")
--   LESSER_ENDURANCE    skill^2/80 + 25                skill/30, 2 when that is 0
--   ENDURANCE           skill^2/60 + 40                skill/20, 2 when 1..19, 5 when skill > 95
--   GREATER_ENDURANCE   skill^2/40 + 50                skill/15, 7 when skill > 95
--   VITALITY            skill^2/35 + 75                skill/20, 2 when 1..19, 5 when skill > 95
--   GREATER_VITALITY    skill^2/30 + 75                skill/15, 7 when skill > 95
--   DRAGONS_HEALTH      skill^2/20 + 90                skill/10
--   DIVINE_ESSENCE      group spell: Greater Endurance + Bless (perform_mag_group)
--
-- The import had Lesser/Endurance/Greater Endurance (and the Divine Essence row copied from it, 37b892b) on max_move
-- with the wrong amounts, and Vitality / Greater Vitality / Dragon's Health on max_hp with flat skill-based amounts and
-- none of the legacy duration floors. The missing floors are why a potion quaffed by a non-caster (skill 0) applied a
-- +0 effect that lasted one second. Floors are written with the engine's formula grammar (no comparisons): `if(x, a, b)`
-- is truthy on non-zero, `clamp(skill - 95, 0, 1)` is "skill > 95".
--
-- Keyed ONLY by Ability.plain_name (ids differ between dev and prod) and guarded on the exact old override_params, so a
-- second run changes 0 rows and builder edits survive. Source of truth for reimports: data/abilities.json.
BEGIN;

WITH fix(plain_name, ord, old_p, new_p) AS (
  VALUES
  ('LESSER_ENDURANCE', 0,
   '{"amount": "skill / 4", "target": "max_move", "duration": "skill / 30", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 80 + 25 - random(2, 10)", "target": "max_hp", "duration": "if(skill / 30, skill / 30, 2)", "durationUnit": "hours"}'::jsonb),
  ('ENDURANCE', 0,
   '{"amount": "skill / 2", "target": "max_move", "duration": "skill / 20", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 60 + 40 - random(2, 10)", "target": "max_hp", "duration": "if(clamp(skill - 95, 0, 1), 5, if(skill / 20, skill / 20, 2 * clamp(skill, 0, 1)))", "durationUnit": "hours"}'::jsonb),
  ('GREATER_ENDURANCE', 0,
   '{"amount": "skill", "target": "max_move", "duration": "skill / 15", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 40 + 50 - random(2, 10)", "target": "max_hp", "duration": "if(clamp(skill - 95, 0, 1), 7, skill / 15)", "durationUnit": "hours"}'::jsonb),
  ('DIVINE_ESSENCE', 1,
   '{"amount": "skill", "target": "max_move", "duration": "skill / 15", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 40 + 50 - random(2, 10)", "target": "max_hp", "duration": "if(clamp(skill - 95, 0, 1), 7, skill / 15)", "durationUnit": "hours"}'::jsonb),
  ('VITALITY', 0,
   '{"amount": "skill / 2", "target": "max_hp", "duration": "skill / 20", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 35 + 75 - random(2, 10)", "target": "max_hp", "duration": "if(clamp(skill - 95, 0, 1), 5, if(skill / 20, skill / 20, 2 * clamp(skill, 0, 1)))", "durationUnit": "hours"}'::jsonb),
  ('GREATER_VITALITY', 0,
   '{"amount": "skill", "target": "max_hp", "duration": "skill / 15", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 30 + 75 - random(2, 10)", "target": "max_hp", "duration": "if(clamp(skill - 95, 0, 1), 7, skill / 15)", "durationUnit": "hours"}'::jsonb),
  ('DRAGONS_HEALTH', 0,
   '{"amount": "skill * 2", "target": "max_hp", "duration": "skill / 10", "durationUnit": "hours"}'::jsonb,
   '{"amount": "pow(skill, 2) / 20 + 90 - random(2, 10)", "target": "max_hp", "duration": "skill / 10", "durationUnit": "hours"}'::jsonb)
)
UPDATE "AbilityEffect" ae
SET override_params = fix.new_p
FROM fix, "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = fix.plain_name
  AND ae."order" = fix.ord
  AND ae.override_params = fix.old_p;

COMMIT;
