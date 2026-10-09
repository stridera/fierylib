-- Remove Paralysis lifts Minor Paralysis, Major Paralysis and Entangle (legacy fierymud main,
-- magic.cpp:4837-4860 mag_unaffect SPELL_REMOVE_PARALYSIS; spells.cpp:1878 spell_remove_paralysis).
--
-- The cleanse row used condition "paralysis", which names no ability and no live effect instance (the
-- status instances are called "paralyzed" / "webbed"), so the spell removed nothing. The runtime matches a
-- condition against the effect instance name or the plain name of the ability that put it there, and every
-- status instance records its casting ability, so the plain names MINOR_PARALYSIS, MAJOR_PARALYSIS and
-- ENTANGLE are enough: they also cover Entangle's upgrade to a "paralyzed" instance. Matching on the
-- instance names "paralyzed" / "webbed" instead would also strip Web, Bind and Bone Cage, which legacy
-- leaves alone. One row with a condition list, so a target held by several gets the legacy line once.
-- The victim / room lines ("Your body begins to move again.") already sit on the cleanse row and print only
-- when something was lifted; the catalog's "dispels the magic" lines (printed on every cast, true or not)
-- are cleared.
-- Source of truth for reimports: data/abilities.json (tests/test_remove_paralysis.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each
-- statement only touches a row still in the old shape, so a second run changes 0 rows and builder edits
-- made afterwards survive.

UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
      ae.override_params,
      '{condition}',
      jsonb_build_array('minor_paralysis', 'major_paralysis', 'entangle'))
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'REMOVE_PARALYSIS'
  AND e.name = 'cleanse'
  AND ae.override_params->>'condition' = 'paralysis';

UPDATE "AbilityMessages" am
SET success_to_caster = CASE WHEN am.success_to_caster = 'You dispel the magic affecting {target.him}.'
                             THEN NULL ELSE am.success_to_caster END,
    success_to_victim = CASE WHEN am.success_to_victim = '{actor.name} dispels the magic affecting you.'
                             THEN NULL ELSE am.success_to_victim END,
    success_to_room = CASE WHEN am.success_to_room = '{actor.name} dispels the magic affecting {target.him}.'
                           THEN NULL ELSE am.success_to_room END
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'REMOVE_PARALYSIS'
  AND (am.success_to_caster = 'You dispel the magic affecting {target.him}.'
       OR am.success_to_victim = '{actor.name} dispels the magic affecting you.'
       OR am.success_to_room = '{actor.name} dispels the magic affecting {target.him}.');

UPDATE "Ability" a
SET description = '<healing>Frees</> the target from Minor Paralysis, Major Paralysis and Entangle. Other holds, such as Web, are left alone.',
    notes = 'Legacy (magic.cpp:4837-4860 mag_unaffect SPELL_REMOVE_PARALYSIS; spells.cpp:1878 spell_remove_paralysis): removes SPELL_MINOR_PARALYSIS, SPELL_MAJOR_PARALYSIS and SPELL_ENTANGLE. Web is not lifted (cleric.cpp:54 mob AI lists it as curable, but neither handler touches it). The victim line / room line print only when one of them was removed.'
WHERE a.plain_name = 'REMOVE_PARALYSIS'
  AND a.description = 'Frees the target from magical paralysis effects.';
