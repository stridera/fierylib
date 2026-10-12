-- Port of the legacy v2 reworks for Glory (stridera/fierymud#405) and Eye Gouge (#403)
-- (fierymud-rs issue #144).
--
-- Glory: the import dropped the spell's flag effect. Legacy `SPELL_GLORY` sets EFF_GLORY on
-- effect slot 0 (duration 5 + skill / 20) and +50 CHA on slot 1 with the same duration; here
-- only the CHA row survived, with its duration pointing at the missing slot ("eff[0].duration").
-- Add the `glory` status row, which the engine turns into the Glory marker (mobs that see a
-- glorion hold back from aggro, with a small chance to attack it), and give the CHA row the
-- real duration.
--
-- Eye Gouge: `"attackRoll": true` on its first effect row makes the skill roll to hit with the
-- melee accuracy/evasion contest (skill adds skill / 2 accuracy) and then dodge/parry, instead
-- of always landing (legacy "make gouge more like an attack roll").
--
-- Idempotent and guarded on the exact current values: a builder's edit in Muditor is never
-- overwritten and a second run changes 0 rows.
-- Keep in sync with data/abilities.json (Glory, Eye Gouge).

BEGIN;

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{duration}', '"5 + (skill / 20)"'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.name = 'Glory'
  AND ae."order" = 1
  AND ae.override_params ->> 'duration' = 'eff[0].duration';

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       '{"flag": "glory", "duration": "5 + (skill / 20)", "durationUnit": "hours"}'::jsonb,
       0, 'on_cast', 100
FROM "Ability" a, "Effect" e
WHERE a.name = 'Glory'
  AND e.name = 'status'
  AND NOT EXISTS (
      SELECT 1 FROM "AbilityEffect" x
      WHERE x.ability_id = a.id AND x.override_params ->> 'flag' = 'glory'
  )
  AND NOT EXISTS (
      SELECT 1 FROM "AbilityEffect" x
      WHERE x.ability_id = a.id AND x.effect_id = e.id AND x."order" = 0
  );

UPDATE "AbilityEffect" ae
SET override_params = ae.override_params || '{"attackRoll": true}'::jsonb
FROM "Ability" a, "Effect" e
WHERE a.id = ae.ability_id
  AND e.id = ae.effect_id
  AND a.name = 'Eye Gouge'
  AND e.name = 'status'
  AND ae."order" = 0
  AND ae.override_params = '{"flag": "blind", "duration": 1, "durationUnit": "hours"}'::jsonb;

COMMIT;
