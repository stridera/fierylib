-- Enchant Weapon (fierymud-rs): the spell's only effect was a "modify" row targeting the stat key
-- 'item_bonus', which the runtime has no stat for, so casting it changed nothing.
-- Legacy spell_enchant_weapon (src/spells.cpp): a non-magical weapon with no applies gets ITEM_MAGIC
-- and applies HITROLL 1 + (skill >= 18) and DAMROLL 1 + (skill >= 20); a good caster bars evil
-- wielders (ITEM_ANTI_EVIL, "glows blue"), an evil caster bars good ones ("glows red"), a neutral
-- caster bars none ("glows yellow"). Anything else (non-weapon, already magic, already has applies)
-- is silently refused. fierymud-rs now runs that as the "enchant" mode of the alter_object effect:
-- per-instance applies stored in the item's CharacterItems.custom_values ('curse' key), granted on
-- wield and released on remove. Amounts are in modern units, the way the object importer converts
-- legacy applies (hitroll x2 -> accuracy, damroll x5 -> attack_power).
-- Source of truth: data/abilities.json (tests/test_enchant_weapon.py keeps them in sync).
--
-- Idempotent: the old modify row is only removed while it still targets 'item_bonus', and every
-- insert is guarded, so a second run changes nothing and builder edits survive.
UPDATE "Effect"
SET description = description || ' The enchant mode (Enchant Weapon) gives a non-magical weapon per-instance stat applies, the MAGIC flag and an anti-alignment bar.'
WHERE name = 'alter_object' AND description NOT LIKE '%enchant mode%';

DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id AND ae.effect_id = e.id
  AND a.plain_name = 'ENCHANT_WEAPON'
  AND e.name = 'modify'
  AND ae.override_params->>'target' = 'item_bonus';

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "enchant", "requireType": "WEAPON", "setFlags": ["MAGIC"], "applies": [{"target": "accuracy", "amount": "2 + 2 * clamp(skill - 17, 0, 1)"}, {"target": "attack_power", "amount": "5 + 5 * clamp(skill - 19, 0, 1)"}], "goodCasterBars": "EVIL", "evilCasterBars": "GOOD", "messageToCasterGood": "{item} glows blue.", "messageToCasterEvil": "{item} glows red.", "messageToCasterNeutral": "{item} glows yellow."}'::jsonb,
       0, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'ENCHANT_WEAPON' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

-- Legacy targets: TAR_OBJ_INV | TAR_OBJ_EQUIP (carried or worn, never one on the floor).
INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range)
SELECT a.id, ARRAY['OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0
FROM "Ability" a
WHERE a.plain_name = 'ENCHANT_WEAPON'
ON CONFLICT (ability_id) DO NOTHING;
