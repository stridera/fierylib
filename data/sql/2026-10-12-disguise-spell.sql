-- fierymud-rs #143 (daedela): "a new spell effect that Statue and Hearthsong place ... a Circle 4/5 Illusionist spell
-- ... 'Disguise' ... a version of Familiarity that's removed when entering combat."
--
-- The engine side is the generic status param `breakOnCombat` (effects::break_on_combat_tick): any ability's `status` row
-- carrying `"breakOnCombat": true` is stripped from its bearer as soon as the bearer is fighting (attacked, attacking, or
-- drawn in), through the normal effect teardown, with the ability's wear-off lines (or the row's optional
-- `breakMessage` / `breakRoomMessage`). Non-combat actions never end it.
--
--   * New SPELL Disguise (Illusionist circle 4, level 25; Familiarity itself is circle 9): the `familiarity` status flag (the
--     Familiar marker: aggressive mobs never start a fight with the bearer) for 5 + skill / 10 hours, with breakOnCombat.
--   * Statue: both of its status rows (statue, familiarity) gain breakOnCombat, so the statue ends as one piece.
--   * Hearthsong: legacy cast Familiarity on the group (magic.cpp:3421); the DB row only had a focus buff. It gains a second
--     status row, the same disguise (familiarity + breakOnCombat), with its own break lines.
--   * Spell help entry `disguise`, and the Illusionist `spell_*` help list is rebuilt by 2026-10-12-class-spell-lists.sql
--     (re-run it after this file).
-- Source of truth for reimports: data/abilities.json, data/classes.json (tests/test_disguise_spell.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name, Effect.name and Class.plain_name (ids differ between dev and prod). Idempotent: every
-- statement inserts a missing row or only touches the old shape, so a second run changes 0 rows and builder edits survive.
BEGIN;

-- 1. The spell.
INSERT INTO "Ability"
  (name, plain_name, description, "abilityType", "minPosition", violent, cast_time_rounds, cooldown_ms, in_combat_only,
   combat_ok, is_area, target_scope, is_magical, is_toggle, notes, sphere, pages, memorization_time, updated_at)
SELECT
  'Disguise', 'DISGUISE',
  'Wraps the target in a convincing disguise that makes hostile creatures take them for a friend, just as Familiarity does. The disguise is fragile: it melts away the moment the bearer attacks or is attacked.',
  'SPELL', 'STANDING'::"Position", false, 3, 0, false,
  false, false, 'SINGLE'::"TargetScope", true, false,
  'Issue #143 (daedela): a version of Familiarity that is removed when the bearer enters combat. Applies the status flag ''familiarity'' (the Familiar marker: aggressive mobs never pick a fight with the bearer, helpers may stop short of assisting against them) with breakOnCombat true, so the engine strips it as soon as the bearer attacks or is drawn into a fight (effects::break_on_combat_tick). Illusionist circle 4 (Familiarity is circle 9). Duration is Familiarity''s, 5 + skill / 10 hours. Statue and Hearthsong place the same effect: their familiarity row carries the same breakOnCombat marker.',
  'ENCHANTMENT'::"SpellSphere", 12, 0, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "Ability" WHERE plain_name = 'DISGUISE');

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       '{"duration": "5 + (skill / 10)", "flag": "familiarity", "breakOnCombat": true, "durationUnit": "hours"}'::jsonb,
       0, 'on_cast', 100
FROM "Ability" a
JOIN "Effect" e ON e.name = 'status'
WHERE a.plain_name = 'DISGUISE'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT DO NOTHING;

INSERT INTO "AbilityMessages"
  (ability_id, success_to_caster, success_to_victim, success_to_room, success_to_self, success_self_room,
   wearoff_to_target, wearoff_to_room)
SELECT a.id,
       'You disguise {target.name}.',
       'You take on a disguise that fools the unwary.',
       '{target.name} takes on a disguise.',
       'You take on a disguise that fools the unwary.',
       '{actor.name} takes on a disguise.',
       'Your disguise melts away.',
       '{actor.name}''s disguise melts away.'
FROM "Ability" a
WHERE a.plain_name = 'DISGUISE'
  AND NOT EXISTS (SELECT 1 FROM "AbilityMessages" m WHERE m.ability_id = a.id);

-- 2. Illusionist, circle 4 (level 25 via ClassAbilityCircles).
INSERT INTO "ClassAbilities" (class_id, ability_id, circle)
SELECT c.id, a.id, 4
FROM "Class" c
JOIN "Ability" a ON a.plain_name = 'DISGUISE'
WHERE c.plain_name = 'Illusionist'
ON CONFLICT (class_id, ability_id) DO NOTHING;

-- 3. Statue: the whole disguise (statue + familiarity rows) ends when the bearer enters combat.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(COALESCE(ae.override_params, '{}'::jsonb), '{breakOnCombat}', 'true'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'STATUE'
  AND ae.override_params->>'flag' IN ('statue', 'familiarity')
  AND COALESCE(ae.override_params->>'breakOnCombat', '') <> 'true';

UPDATE "Ability"
SET description = description || ' The disguise ends if the caster enters combat.',
    notes = COALESCE(notes || ' ', '') || 'Both rows carry breakOnCombat (the Disguise marker), so entering combat ends the statue and its familiarity together.'
WHERE plain_name = 'STATUE'
  AND description NOT LIKE '%The disguise ends if the caster enters combat.%';

-- 4. Hearthsong: the group also takes on the disguise (second status row, after the focus buff).
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id,
       '{"duration": "5 + (skill / 10)", "flag": "familiarity", "breakOnCombat": true, "breakMessage": "Your familiar disguise melts away as the fighting begins.", "breakRoomMessage": "{actor.name}''s familiar disguise melts away as the fighting begins.", "durationUnit": "hours"}'::jsonb,
       1, 'on_cast', 100
FROM "Ability" a
JOIN "Effect" e ON e.name = 'status'
WHERE a.plain_name = 'HEARTHSONG'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x
    WHERE x.ability_id = a.id AND x.effect_id = e.id AND x.override_params->>'flag' = 'familiarity')
ON CONFLICT DO NOTHING;

UPDATE "Ability"
SET description = description || ' Everyone in the song''s reach also takes on a familiar disguise, so hostile creatures take them for friends, until a fight breaks out.',
    notes = COALESCE(notes || ' ', '') || 'Also places the Disguise effect (status familiarity, breakOnCombat) on the group, as legacy Hearthsong cast Familiarity on it (magic.cpp:3421).'
WHERE plain_name = 'HEARTHSONG'
  AND description NOT LIKE '%also takes on a familiar disguise%';

-- 5. Spell help entry, in the shape of the other spell entries; never overwrites an existing `disguise` entry.
INSERT INTO "HelpEntry"
  (keywords, title, content, min_level, category, usage, duration, sphere, updated_at)
SELECT
  ARRAY['disguise']::text[],
  'Disguise',
  $help$===============================================
Usage         : cast 'disguise' [<target>]
Min. position : standing
OK in combat  : no
Aggressive    : no
Effect        : support
Area of effect: single target
Accumulative  : no
Duration      : 5 - 15 hours
Sphere        : enchantment
Fade message  : Your disguise melts away.
Classes       : Illusionist      Circle 4
===============================================

The DISGUISE spell makes one appear to be familiar to everyone. Creatures
are far less likely to be hostile to one so affected. The disguise does
not survive a fight: it melts away the moment the bearer attacks or is
attacked.

See also: FAMILIARITY, STATUE, HEARTHSONG$help$,
  0,
  'spell',
  'cast ''disguise'' [<target>]',
  '5 - 15 hours',
  'enchantment',
  CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "HelpEntry" WHERE 'disguise' = ANY(keywords));

COMMIT;
