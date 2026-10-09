-- Sane Mind removes only insanity, confusion and crown of madness (legacy fierymud main, magic.cpp:4808
-- mag_unaffect SPELL_SANE_MIND; skills.cpp:1151 spello MAG_UNAFFECT, no spells.cpp special case).
--
-- The row was a cleanse of condition "all", which stripped every effect from the target, Sanctuary and
-- Bless included. It now cleanses the three conditions (the runtime matches a condition against the effect
-- instance name or the plain name of the ability that put it there: INSANITY, CONFUSION, CROWN_OF_MADNESS).
-- One row with a condition list, so a target afflicted by several gets the legacy line once, not once per
-- condition. Legacy prints "Your mind comes back to reality." / "$n regains $s senses." only when something
-- was removed: those lines live on the cleanse row (message / roomMessage), and the catalog's
-- "dispels the magic" lines (printed on every cast, true or not) are cleared.
-- Source of truth for reimports: data/abilities.json (tests/test_sane_mind_cleanse.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each
-- statement only touches a row still in the old shape, so a second run changes 0 rows and builder edits
-- made afterwards survive.

UPDATE "AbilityEffect" ae
SET override_params = jsonb_build_object(
      'condition', jsonb_build_array('insanity', 'confusion', 'crown_of_madness'),
      'scope', 'all',
      'message', 'Your mind comes back to reality.',
      'roomMessage', '{target.name} regains {target.his} senses.')
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'SANE_MIND'
  AND e.name = 'cleanse'
  AND ae.override_params->>'condition' = 'all';

UPDATE "AbilityMessages" am
SET success_to_caster = CASE WHEN am.success_to_caster = 'You dispel the magic affecting {target.him}.'
                             THEN NULL ELSE am.success_to_caster END,
    success_to_victim = CASE WHEN am.success_to_victim = '{actor.name} dispels the magic affecting you.'
                             THEN NULL ELSE am.success_to_victim END,
    success_to_room = CASE WHEN am.success_to_room = '{actor.name} dispels the magic affecting {target.him}.'
                           THEN NULL ELSE am.success_to_room END
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'SANE_MIND'
  AND (am.success_to_caster = 'You dispel the magic affecting {target.him}.'
       OR am.success_to_victim = '{actor.name} dispels the magic affecting you.'
       OR am.success_to_room = '{actor.name} dispels the magic affecting {target.him}.');

UPDATE "Ability" a
SET description = '<healing>Restores</> mental clarity, removing insanity, confusion and crown of madness from the target. Other magic on the target is left alone.',
    notes = 'Legacy MAG_UNAFFECT (magic.cpp:4808 mag_unaffect SPELL_SANE_MIND): removes only SPELL_INSANITY, SPELL_CONFUSION and SONG_CROWN_OF_MADNESS; the victim line / room line print only when one of them was removed.'
WHERE a.plain_name = 'SANE_MIND'
  AND a.description = '<healing>Restores</> mental clarity and removes confusion effects from the target.';
