-- Blindness spells and cures as data (fierymud-rs 29b793e Blinded marker, fierymud-rs 3d8dc9a cleanse).
-- Legacy source (fierymud main):
--   SPELL_BLINDNESS / SPELL_BLINDING_BEAUTY (magic.cpp:1259-1287): MOB_NOBLIND refuses; mag_savingthrow
--     negates; otherwise EFF_BLIND for 2 ticks, with APPLY_HITROLL -4 and APPLY_AC -40 riding on the
--     same affect (the existing accuracy / evasion modify rows, kept). Wear-off: skills.cpp:548-553.
--   SPELL_CURE_BLIND (magic.cpp:4662-4685, skills.cpp:650): MAG_UNAFFECT only, no healing; it strips
--     blindness, eye gouge, blinding beauty and sunray, "Your vision returns!".
--   SKILL_EYE_GOUGE (act.offensive.cpp:1431-1445): unless MOB_NOBLIND or already blind, EFF_BLIND for
--     1 tick with APPLY_HITROLL -(2 + skill/10), then pierce damage. Wear-off: skills.cpp:1419.
-- The runtime reads `status` flag "blind" (an instance named `blind`, which `cleanse` condition
-- `blind` removes along with the rest of that spell's penalties). Source of truth for reimports:
-- data/abilities.json (tests/test_blindness_abilities.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent:
-- every statement is guarded on the state it creates, so a second run changes 0 rows and builder
-- edits made afterwards survive.

-- Blindness / Blinding Beauty: add the missing blind status (2 ticks = 2 "hours").
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id, '{"flag": "blind", "duration": 2, "durationUnit": "hours"}'::jsonb, 0, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name IN ('BLINDNESS', 'BLINDING_BEAUTY')
  AND e.name = 'status'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'status')
ON CONFLICT DO NOTHING;

-- Cure Blind: a cleanse of the blind condition instead of a 1d8 heal.
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id, '{"condition": "blind", "scope": "all"}'::jsonb, 0, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'CURE_BLIND'
  AND e.name = 'cleanse'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'cleanse')
ON CONFLICT DO NOTHING;

DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'CURE_BLIND'
  AND e.name = 'heal'
  AND ae.override_params->>'amount' = '1d8';

UPDATE "AbilityMessages" m
SET success_to_caster = 'You cure {target.name}''s blindness.',
    success_to_victim = 'Your vision returns!',
    success_to_room = 'There''s a momentary gleam in {target.name}''s eyes.',
    success_to_self = 'Your vision returns!',
    success_self_room = 'There''s a momentary gleam in {actor.name}''s eyes.'
FROM "Ability" a
WHERE m.ability_id = a.id
  AND a.plain_name = 'CURE_BLIND'
  AND m.success_to_caster = 'You channel healing energy into {target.him}.';

-- Eye Gouge: blind status (1 tick) and the skill-scaled accuracy penalty land before the damage,
-- so the damage row moves from order 0 to 2.
UPDATE "AbilityEffect" ae
SET "order" = 2
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'EYE_GOUGE'
  AND e.name = 'damage'
  AND ae."order" = 0
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'status');

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id, '{"flag": "blind", "duration": 1, "durationUnit": "hours"}'::jsonb, 0, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'EYE_GOUGE'
  AND e.name = 'status'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'status')
ON CONFLICT DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       '{"amount": "-2 - skill / 10", "target": "accuracy", "duration": 1, "durationUnit": "hours"}'::jsonb,
       1, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'EYE_GOUGE'
  AND e.name = 'modify'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'modify')
ON CONFLICT DO NOTHING;

UPDATE "AbilityMessages" m
SET wearoff_to_target = 'Your vision returns.'
FROM "Ability" a
WHERE m.ability_id = a.id
  AND a.plain_name = 'EYE_GOUGE'
  AND COALESCE(m.wearoff_to_target, '') = '';
