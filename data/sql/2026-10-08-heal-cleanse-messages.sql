-- Group Heal heal amount + per-condition cleanse messages (legacy fierymud main, magic.cpp).
--
-- 1. Group Heal. perform_mag_group (magic.cpp:3414) heals every group member with
--    mag_point(SPELL_HEAL) + mag_unaffect(SPELL_HEAL), i.e. exactly what Heal does, so it takes Heal's
--    amount formula instead of the "1d8" placeholder. (spell_dams has no usable row: SPELL_GROUP_HEAL
--    and SPELL_HEAL are both all-zero there, mag_point does not read it.) No other heal row carries a
--    placeholder amount.
-- 2. Cleanse messages. mag_unaffect (magic.cpp:4660-4890) prints a line to the cured person, and for some
--    spells one to the room, ONLY when something was removed. The cleanse arm now reads those from
--    AbilityEffect.override_params: "message" (to the target) and "roomMessage" (to the rest of the room).
--    Cure Blind's catalog victim / room lines moved there too, so they no longer print on a target that
--    was not blind.
-- Source of truth for reimports: data/abilities.json (tests/test_heal_cleanse_messages.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each
-- statement only touches a row still in the old shape, so a second run changes 0 rows and builder edits
-- made afterwards survive.

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{amount}', '"100 + roll_dice(2, 9) + skill / 5"'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'GROUP_HEAL'
  AND e.name = 'heal'
  AND ae.override_params->>'amount' = '1d8';

UPDATE "AbilityEffect" ae
SET override_params = ae.override_params
    || jsonb_strip_nulls(jsonb_build_object('message', m.message, 'roomMessage', m.room_message))
FROM "Ability" a, "Effect" e,
     (VALUES
       ('CURE_BLIND', 'blind', 'Your vision returns!', 'There''s a momentary gleam in {target.name}''s eyes.'),
       ('HEAL', 'blind', 'Your vision returns!', 'There''s a momentary gleam in {target.name}''s eyes.'),
       ('FULL_HEAL', 'blind', 'Your vision returns!', 'There''s a momentary gleam in {target.name}''s eyes.'),
       ('GROUP_HEAL', 'blind', 'Your vision returns!', 'There''s a momentary gleam in {target.name}''s eyes.'),
       ('HEAL', 'poison', 'The poison in your system has been cleansed.', NULL),
       ('FULL_HEAL', 'poison', 'The poison in your system has been cleansed.', NULL),
       ('GROUP_HEAL', 'poison', 'The poison in your system has been cleansed.', NULL),
       ('HEAL', 'disease', 'Your disease has been cured.', NULL),
       ('FULL_HEAL', 'disease', 'Your disease has been cured.', NULL),
       ('GROUP_HEAL', 'disease', 'Your disease has been cured.', NULL),
       ('REMOVE_POISON', 'poison', 'A warm feeling runs through your body!', '{target.name} looks better.'),
       ('REMOVE_CURSE', 'curse', 'You don''t feel so unlucky.', NULL),
       ('REMOVE_PARALYSIS', 'paralysis', '<b:yellow>Your body begins to move again.</>',
        '<b:yellow>{target.name} begins to move again.</>')
     ) AS m(plain_name, condition, message, room_message)
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = m.plain_name
  AND e.name = 'cleanse'
  AND ae.override_params->>'condition' = m.condition
  AND NOT (ae.override_params ? 'message');

-- Cure Blind: the catalog's victim / room lines now come from the cleanse row, only when sight returns.
UPDATE "AbilityMessages" am
SET success_to_victim = CASE WHEN am.success_to_victim = 'Your vision returns!' THEN NULL ELSE am.success_to_victim END,
    success_to_self = CASE WHEN am.success_to_self = 'Your vision returns!' THEN NULL ELSE am.success_to_self END,
    success_to_room = CASE WHEN am.success_to_room = 'There''s a momentary gleam in {target.name}''s eyes.'
                           THEN NULL ELSE am.success_to_room END,
    success_self_room = CASE WHEN am.success_self_room = 'There''s a momentary gleam in {actor.name}''s eyes.'
                             THEN NULL ELSE am.success_self_room END
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'CURE_BLIND'
  AND (am.success_to_victim = 'Your vision returns!'
       OR am.success_to_self = 'Your vision returns!'
       OR am.success_to_room = 'There''s a momentary gleam in {target.name}''s eyes.'
       OR am.success_self_room = 'There''s a momentary gleam in {actor.name}''s eyes.');
