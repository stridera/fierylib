-- fierymud-rs #35: "Ice Dagger cast message missing color coding". Legacy spell_ice_dagger (src/spells.cpp)
-- coloured both lines: "&7&bYou summon a blade of &0&4glimmering ice&7&b to aid you.&0" (bold white, with the ice
-- in plain blue) and the same for the room. The 2026-10-10 patch re-wrote the messages as plain text; this restores
-- the colour in the modern markup (the fierylib converter's output for the legacy strings).
-- Keyed by Ability.plain_name; only rewrites a row still holding the plain text, so a second run changes 0 rows and
-- builder-edited messages survive.
UPDATE "AbilityMessages" m
SET success_to_caster = '<b:white>You summon a blade of </><blue>glimmering ice</><b:white> to aid you.</>',
    success_to_room = '<b:white>{actor.name} summons a dagger of </><blue>glimmering ice</><b:white> to aid {actor.him}.</>'
FROM "Ability" a
WHERE m.ability_id = a.id
  AND a.plain_name = 'ICE_DAGGER'
  AND m.success_to_caster = 'You summon a blade of glimmering ice to aid you.'
  AND m.success_to_room = '{actor.name} summons a dagger of glimmering ice to aid {actor.him}.';
