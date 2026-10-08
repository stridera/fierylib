-- Issue stridera/fierymud-rs#77: Curse must work on objects (and Remove Curse must undo it).
-- Legacy magic.cpp mag_alter_obj: SPELL_CURSE sets ITEM_NODROP and shrinks a weapon's dice size by 1,
-- SPELL_REMOVE_CURSE clears ITEM_NODROP and restores the die; skills.cpp lists
-- TAR_CHAR_ROOM | TAR_OBJ_INV | TAR_OBJ_ROOM for both.
--
-- 1. New "alter_object" Effect (also in data/effects.json; the Rust runtime has an arm for it).
-- 2. AbilityEffect rows binding it to CURSE (add NO_DROP, -1 die) and REMOVE_CURSE (remove, +1 die).
-- 3. AbilityTargeting rows so both spells accept inventory and floor objects.
-- Source of truth: data/abilities.json + data/effects.json (tests/test_curse_objects.py keeps them in sync).
--
-- Idempotent: every insert is guarded (unique name / primary key / existing row), so a second run
-- changes nothing and builder edits survive.
INSERT INTO "Effect" (name, description, "effectType", tags, default_params, category_id)
SELECT 'alter_object',
       'Change an object in place: add or remove a restriction such as NO_DROP (curse / remove curse), optionally shifting a weapon''s dice size. Runs when the spell targets an object; on a person, the remove form lifts the restriction from the first carried object.',
       'alter_object',
       ARRAY['utility', 'magic', 'item'],
       '{"restriction": "NO_DROP", "mode": "add", "weaponDiceSizeDelta": 0}'::jsonb,
       (SELECT category_id FROM "Effect" WHERE name = 'enchant')
WHERE NOT EXISTS (SELECT 1 FROM "Effect" WHERE name = 'alter_object');

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"restriction": "NO_DROP", "mode": "add", "weaponDiceSizeDelta": -1, "messageToCaster": "{item} briefly glows red.", "messageToRoom": "{item} briefly glows red."}'::jsonb,
       2, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'CURSE' AND e.name = 'alter_object'
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"restriction": "NO_DROP", "mode": "remove", "weaponDiceSizeDelta": 1, "messageToCaster": "{item} briefly glows blue.", "messageToRoom": "{item} briefly glows blue.", "noopMessageToCaster": "You do not sense any foul magicks upon {item}."}'::jsonb,
       1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'REMOVE_CURSE' AND e.name = 'alter_object'
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range)
SELECT a.id, ARRAY['ENEMY_PC', 'ENEMY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0
FROM "Ability" a
WHERE a.plain_name = 'CURSE'
ON CONFLICT (ability_id) DO NOTHING;

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0
FROM "Ability" a
WHERE a.plain_name = 'REMOVE_CURSE'
ON CONFLICT (ability_id) DO NOTHING;

UPDATE "Ability"
SET description = description || '  Cast on an object (carried or on the ground) it makes the object impossible to drop, and a weapon loses one die size.'
WHERE plain_name = 'CURSE' AND description NOT LIKE '%impossible to drop%';
