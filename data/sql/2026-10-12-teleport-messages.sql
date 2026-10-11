-- fierymud-rs #127: "Spell completion text incorrect" - 14 teleport / gate / summon spells shared the
-- placeholder "You vanish in a flash of light!". Each spell now carries its own legacy completion text
-- (spells.cpp spell_dimension_door / relocate / plane_shift / teleport / recall / summon / moonwell /
-- heavens_gate / hells_gate / summon_corpse / shift_corpse, converted to template syntax and to the
-- modern colour markup). Recall, Word of Recall and Group Recall had no caster line in legacy (the
-- traveller just sees the new room), so success_to_caster is cleared for them.
-- Keyed by Ability.plain_name; a row is only rewritten while BOTH of its success lines are still the old
-- placeholder text, so a second run changes 0 rows and builder-edited messages are never overwritten.

-- DIMENSION_DOOR
UPDATE "AbilityMessages" am
SET success_to_caster = '<b:black>You quickly enter the black rift that tears open at your command...</>',
    success_to_room = '<b:black>A black rift in space tears open and {actor.name} steps inside.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'DIMENSION_DOOR'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- RELOCATE
UPDATE "AbilityMessages" am
SET success_to_caster = '<b:white>Your body begins to fade from existence, </><b:black>then you black out...</>',
    success_to_room = '<b:white>{actor.name}''s molecules loosen and eventually dissipate into thin air.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'RELOCATE'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- PLANE_SHIFT
UPDATE "AbilityMessages" am
SET success_to_caster = 'You begin to fade, then reappear.',
    success_to_room = '{actor.name} begins to fade, then reappears.'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'PLANE_SHIFT'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- TELEPORT
UPDATE "AbilityMessages" am
SET success_to_caster = '<b:black>You feel your body being pulled in all directions, then find yourself elsewhere.</>',
    success_to_room = '<b:black>{actor.name} slowly fades out of existence and is gone.</>',
    fail_to_caster = '<white>The spell swirls about and dies away.</>',
    fail_to_room = '<white>{actor.name} tries to teleport {actor.ref}, but fails.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'TELEPORT'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- WORLD_TELEPORT
UPDATE "AbilityMessages" am
SET success_to_caster = '<b:black>You feel your body being pulled in all directions, then find yourself elsewhere.</>',
    success_to_room = '<b:black>{actor.name} slowly fades out of existence and is gone.</>',
    fail_to_caster = '<white>The spell swirls about and dies away.</>',
    fail_to_room = '<white>{actor.name} tries to teleport {actor.ref}, but fails.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'WORLD_TELEPORT'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- RECALL
UPDATE "AbilityMessages" am
SET success_to_caster = NULL,
    success_to_room = '{actor.name} utters a single word... <b:white>{actor.name} disappears in a bright flash of light!</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'RECALL'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- WORD_OF_RECALL
UPDATE "AbilityMessages" am
SET success_to_caster = NULL,
    success_to_room = '{actor.name} utters a single word... <b:white>{actor.name} disappears in a bright flash of light!</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'WORD_OF_RECALL'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- GROUP_RECALL
UPDATE "AbilityMessages" am
SET success_to_caster = NULL,
    success_to_room = '{actor.name} utters a single word... <b:white>{target.name} disappears in a bright flash of light!</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'GROUP_RECALL'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- SUMMON
UPDATE "AbilityMessages" am
SET success_to_caster = '{target.name} arrives suddenly.',
    success_to_victim = '{actor.name} has summoned you!',
    success_to_room = '{target.name} arrives suddenly.'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'SUMMON'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- SUMMON_CORPSE
UPDATE "AbilityMessages" am
SET success_to_caster = 'From within a cloud of <b:black>darkness</>, a corpse materializes.',
    success_to_room = 'From within a cloud of <b:black>darkness</>, a corpse materializes.'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'SUMMON_CORPSE'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- SHIFT_CORPSE
UPDATE "AbilityMessages" am
SET success_to_caster = 'The hand of <b:black>death</> delivers the corpse to your feet.',
    success_to_room = 'The hand of <b:black>death</> delivers the corpse to {actor.name}''s feet.'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'SHIFT_CORPSE'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- MOONWELL
UPDATE "AbilityMessages" am
SET success_to_caster = '<magenta>In a gust of wind a</> <white>moonwell</> <magenta>appears at your feet.</>',
    success_to_victim = '<magenta>In a gust of wind a</> <white>moonwell</> <magenta>appears at your feet.</>',
    success_to_room = '<magenta>In a gust of wind a</> <white>moonwell</> <magenta>appears.</>',
    fail_to_caster = 'A <magenta>moonwell</> <white>appears briefly, then dissolves.</>',
    fail_to_room = 'A <magenta>moonwell</> <white>appears briefly, then dissolves.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'MOONWELL'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- HEAVENS_GATE
UPDATE "AbilityMessages" am
SET success_to_caster = '<b:white>You call upon your deity...</> <cyan>A soft </><b:cyan>tunnel of </><b:white>light </><b:cyan>opens up near you, beckoning you to enter.</>',
    success_to_victim = '<cyan>A soft </><b:cyan>tunnel of </><b:white>light </><b:cyan>opens up near you, beckoning you to enter.</>',
    success_to_room = '<b:white>{actor.name} calls upon {actor.pos} deity...</> <cyan>A soft </><b:cyan>tunnel of </><b:white>light</><b:cyan> opens up near you, beckoning you to enter.</>',
    fail_to_caster = '<white>A </><b:cyan>tunnel of </><b:white>light</> <white>appears briefly, then vanishes.</>',
    fail_to_room = '<white>A </><b:cyan>tunnel of </><b:white>light</> <white>appears briefly, then vanishes.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'HEAVENS_GATE'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';

-- HELLS_GATE
UPDATE "AbilityMessages" am
SET success_to_caster = '<red>A </><b:black>dark hole in the </><yellow>earth</><red> opens up to </><b:red>hell.</>',
    success_to_victim = '<red>A </><b:black>dark hole in the </><yellow>earth</><red> opens up to </><b:red>hell.</>',
    success_to_room = '<red>A </><b:black>dark hole in the </><yellow>earth</><red> opens up to </><b:red>hell.</>',
    fail_to_caster = '<b:black>The ground begins to quake and open up, briefly revealing </><b:red>hell</><b:black>, then closes.</>',
    fail_to_room = '<b:black>The ground begins to quake and open up, briefly revealing </><b:red>hell</><b:black>, then closes.</>'
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'HELLS_GATE'
  AND am.success_to_caster = 'You vanish in a flash of light!'
  AND am.success_to_room = '{actor.name} vanishes in a flash of light!';
