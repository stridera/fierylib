-- Blindness follow-ups: Sunray, Heal / Full Heal / Group Heal, Blinding Beauty (area).
-- Legacy source (fierymud main):
--   SPELL_SUNRAY (skills.cpp:1237 MAG_DAMAGE|MAG_AFFECT, TAR_CHAR_ROOM|TAR_FIGHT_VICT|TAR_DIRECT, DAM_FIRE;
--     class.cpp:2046 druid circle 9). Damage (magic.cpp:463-513, 960-961): lib/misc/spell_dams has
--     155 -> 20d10 vs mobs, 30d10 PC-vs-PC (the PC-vs-PC dice are not expressible; mobs' 20d10 is used),
--     plus skill^2 * 7 / 400, fire, never saved against, no undead / light bonus. Then mag_affect
--     (magic.cpp:2864-2891): MOB_NOBLIND refuses, mag_savingthrow negates only the blinding, otherwise
--     EFF_BLIND for 2 ticks with APPLY_HITROLL -4 and APPLY_AC -40 (the existing accuracy / evasion rows).
--     The damage-keeps-landing save is on_save_action NEGATE_STATUS (fierymud-rs).
--   SPELL_HEAL / SPELL_FULL_HEAL / SPELL_GROUP_HEAL (skills.cpp:840,881; magic.cpp:3415, 4663-4694
--     mag_unaffect): besides healing they strip blindness (and the sunray / eye gouge / blinding beauty
--     affects), disease and poison.
--   SPELL_BLINDING_BEAUTY (skills.cpp:548 TAR_IGNORE MAG_AREA; magic.cpp:3587-3770 mag_area): every valid
--     room attack target gets the Blindness affect; no alignment filter, so ROOM_ENEMIES like Holy Word.
-- Source of truth for reimports: data/abilities.json (tests/test_blindness_abilities_2.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: every
-- statement is guarded on the state it creates, so a second run changes 0 rows and builder edits made
-- afterwards survive.

-- Sunray: the accuracy penalty moves from order 1 to 2 to make room for the blind status at 1; the
-- damage row takes order 0 so it lands before the blinding.
UPDATE "AbilityEffect" ae
SET "order" = 2
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'SUNRAY'
  AND e.name = 'modify'
  AND ae.override_params->>'target' = 'accuracy'
  AND ae."order" = 1
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'status')
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x
    WHERE x.ability_id = a.id AND x.effect_id = ae.effect_id AND x."order" = 2);

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       '{"type": "fire", "amount": "20d10 + (pow(skill, 2) * 7) / 400"}'::jsonb,
       0, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'SUNRAY'
  AND e.name = 'damage'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'damage')
ON CONFLICT DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id, '{"flag": "blind", "duration": 2, "durationUnit": "hours"}'::jsonb, 1, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'SUNRAY'
  AND e.name = 'status'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x JOIN "Effect" xe ON xe.id = x.effect_id
    WHERE x.ability_id = a.id AND xe.name = 'status')
ON CONFLICT DO NOTHING;

-- Sunray's save only turns the blinding away, never the damage.
UPDATE "AbilitySavingThrow" s
SET on_save_action = '"NEGATE_STATUS"'
FROM "Ability" a
WHERE s.ability_id = a.id
  AND a.plain_name = 'SUNRAY'
  AND s.on_save_action = '"NEGATE"';

-- Heal / Full Heal / Group Heal also cure blindness, poison and disease (one cleanse row per condition).
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       jsonb_build_object('condition', c.condition, 'scope', 'all'),
       c.ord, 'on_cast', 100
FROM "Ability" a
CROSS JOIN (VALUES ('blind', 1), ('poison', 2), ('disease', 3)) AS c(condition, ord)
JOIN "Effect" e ON e.name = 'cleanse'
WHERE a.plain_name IN ('HEAL', 'FULL_HEAL', 'GROUP_HEAL')
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x
    WHERE x.ability_id = a.id AND x.effect_id = e.id
      AND x.override_params->>'condition' = c.condition)
ON CONFLICT DO NOTHING;

-- Blinding Beauty: an area spell hitting every room enemy (same shape as Holy Word).
UPDATE "Ability"
SET is_area = true,
    target_scope = 'ROOM_ENEMIES'
WHERE plain_name = 'BLINDING_BEAUTY'
  AND (is_area = false OR target_scope = 'SINGLE');
