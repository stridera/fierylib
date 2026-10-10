-- Spell data follow-ups to fierymud-rs #35 (Dimension Door, Farsee, Waterform). Keyed ONLY by Ability.plain_name
-- and Effect.name (ids differ between dev and prod). Idempotent: each statement only touches a row still in the
-- old shape, so a second run changes 0 rows and builder edits made afterwards survive.
-- Source of truth for reimports: data/abilities.json (tests/test_spell_data_35.py keeps them in sync).

-- Dimension Door: the teleport effect had only {"type": "self"}, so the runtime had no destination and the cast
-- did nothing. Same shape as Relocate ({"type": "self", "destination": "target", "scope": "self"}) plus
-- "range": "zone". Legacy spells.cpp spell_dimension_door: the victim must be a player (not NOFOLLOW, not an
-- immortal) and `world[ch->in_room].zone == world[victim->in_room].zone`, otherwise "Your magics are not strong
-- enough for such a great journey." Relocate has no zone check in legacy (spell_relocate), so it gets no range.
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
    || '{"destination": "target", "scope": "self", "range": "zone"}'::jsonb
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'DIMENSION_DOOR'
  AND e.name = 'teleport'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'destination');

-- Farsee: legacy magic.cpp SPELL_FARSEE sets EFF_FARSEE (5 + skill/10 hours), which lengthens do_scan's reach
-- (act.informative.cpp: maxdis + 1, +1/+1 more on divination rolls). It is not detect hidden. Flag is "farsee".
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{flag}', '"farsee"'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'FARSEE'
  AND e.name = 'status'
  AND ae.override_params->>'flag' = 'detect_hidden';

-- Waterform: legacy magic.cpp SPELL_WATERFORM applies APPLY_COMPOSITION = COMP_WATER (flesh bodies only) for
-- 2 + skill/20 hours. There is no EFF_WATERFORM and no water breathing, so "waterbreath" was wrong. Flag is
-- "waterform"; the composition change itself is a runtime gap.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{flag}', '"waterform"'::jsonb)
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'WATERFORM'
  AND e.name = 'status'
  AND ae.override_params->>'flag' = 'waterbreath';
