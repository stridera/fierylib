---
keywords: [magic, spellcasting, circles, spell-circles, slots, mana]
title: Magic: Spells, Circles and Chants
category: guide
min_level: 0
usage: "cast {spell} [target] | chant {chant} [target] | perform {song} | spells | slots"
---
There is no mana. Magic works on spell slots sorted into circles. A circle
is a tier of power: circle 1 is the weakest, higher circles hold stronger
spells and unlock as you level. Your class and level decide how many slots
you have in each circle.

SEE WHAT YOU HAVE
  spells             the spells you know, grouped by circle
  spells 3           only circle 3          spells 1-2   circles 1 to 2
  spells 2-3 fire    circles 2 and 3 matching "fire"
  spells all         the whole catalog
  slots              free and total slots per circle, and which are
                     recovering. Cooldowns survive logging out.

LEARN
  study {spell}      add a spell from your class list to what you know.
  practice {spell}   raise your proficiency at a trainer (see SKILL).

CAST
  cast fireball goblin       cast at a target; partial names work
  cast 'magic missile' orc   put multi-word names in quotes
  chant {chant} [target]     chants, used by some classes (list: chants)
  perform {song} [target]    songs, used by bards (list: songs)

  Casting takes a few seconds ("You begin casting... about 3s"). "abort"
  stops a cast in progress. A cast uses one slot of the spell's circle and
  starts that circle's recovery timer. You can't cast a spell you haven't
  learned or practiced, one above your level, or one your class lacks. It
  fizzles in rooms where magic doesn't work.

SLOT RECOVERY
  Slots come back by themselves, faster while resting, sleeping or
  sitting, and fastest while you "meditate" or "concentrate".
  (The old commands memorize and forget just show your slots.)

OTHER USEFUL COMMANDS
  recite {scroll} [target]   read a scroll, casting what is written on it
  scribe 'spell name'        write a spell you know (50 percent or better)
                             onto a blank scroll; sit down, out of combat
  effects                    what is affecting you now
  cancel [effect]            list, or drop, a buff you don't want
  cooldowns                  abilities still recharging
  help {spell}               description, cast time and class access

See also: SKILL, GROUPS.
