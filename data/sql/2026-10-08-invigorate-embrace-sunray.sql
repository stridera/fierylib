-- Invigorate, Nature's Embrace and Sunray brought in line with legacy fierymud main.
--
-- INVIGORATE (magic.cpp:4612 mag_point; skills.cpp:969 spello): move = GET_MAX_MOVE(victim), clamped by
--   alter_move to max, no cap and no extra cost. It was a heal of "skill / 2" stamina. It now heals
--   "target_max_stamina" (new fierymud-rs formula symbol: the target's Stamina.max; the heal clamps at max).
-- NATURES_EMBRACE (magic.cpp:4616 mag_point: GET_HIDDENNESS += skill * 5, clamped to 1000; magic.cpp:2448
--   mag_affect: camouflaged for skill / 3 + 1 ticks). It was an HP heal of "skill", which legacy never did.
--   It is now a modify "hiddenness" effect on self (amount "skill * 5", duration "skill / 3 + 1" hours = ticks)
--   with legacy's "phase into the landscape" lines. Legacy's TAR_OUTDOORS gate has no restriction type in the
--   runtime yet and is only noted in the ability notes.
-- SUNRAY (lib misc/spell_dams: pc 30d10, npc 20d10; magic.cpp:510): 30d10 when caster and victim are both
--   players, 20d10 otherwise. The damage amount rolls (20 + 10 * actor_is_player * target_is_player) d10 using
--   the new fierymud-rs symbols actor_is_player / target_is_player, plus the unchanged skill^2*7/400.
-- Source of truth for reimports: data/abilities.json (tests/test_invigorate_embrace_sunray.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each
-- statement only touches a row still in the old shape, so a second run changes 0 rows and builder edits made
-- afterwards survive.

-- Invigorate: heal full max stamina.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_build_object('resource', 'move', 'amount', 'target_max_stamina')
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'INVIGORATE'
  AND e.name = 'heal'
  AND ae.override_params->>'amount' = 'skill / 2';

UPDATE "Ability" a
SET description = '<healing>Restores</> all of the target''s stamina.',
    notes = 'Legacy (magic.cpp:4612 mag_point SPELL_INVIGORATE; spello skills.cpp:969 MAG_GROUP, no mana/cost override, no cap): move = GET_MAX_MOVE(victim), then alter_move clamps to max, so the target is filled to full stamina. ''target_max_stamina'' is the target''s Stamina.max (the heal clamps at max). MAG_GROUP (caster plus grouped allies in the room) is not modelled: single target.'
WHERE a.plain_name = 'INVIGORATE'
  AND a.description = '<healing>Restores</> energy and removes fatigue from the target.';

-- Nature's Embrace: drop the heal, raise hiddenness instead (the same AbilityEffect row, now a modify).
UPDATE "AbilityEffect" ae
SET effect_id = (SELECT m.id FROM "Effect" m WHERE m.name = 'modify'),
    override_params = jsonb_build_object(
      'target', 'hiddenness',
      'amount', 'skill * 5',
      'duration', 'skill / 3 + 1',
      'durationUnit', 'hours')
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'NATURES_EMBRACE'
  AND e.name = 'heal'
  AND EXISTS (SELECT 1 FROM "Effect" m WHERE m.name = 'modify');

UPDATE "AbilityMessages" am
SET success_to_self = COALESCE(am.success_to_self, 'You phase into the landscape.'),
    success_self_room = COALESCE(am.success_self_room, '{actor.name} phases into the landscape.')
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'NATURES_EMBRACE'
  AND (am.success_to_self IS NULL OR am.success_self_room IS NULL);

UPDATE "Ability" a
SET description = 'Phases the caster into the landscape, raising hiddenness. Outdoors only (not enforced yet).',
    notes = 'Legacy (magic.cpp:4616 mag_point SPELL_NATURES_EMBRACE: GET_HIDDENNESS += skill * 5, clamped to 1000, no heal; magic.cpp:2448 mag_affect: EFF_CAMOUFLAGED for skill / 3 + 1 ticks; skills.cpp:1050 TAR_SELF_ONLY | TAR_OUTDOORS). Expressed as a modify ''hiddenness'' effect on self (adds to the Hiddenness component, 0..1000, taken back when it ends). The TAR_OUTDOORS precondition (spell_parser.cpp:1559, ''This area is too enclosed to cast that spell!'') has no restriction type in the runtime yet, so it is not enforced.'
WHERE a.plain_name = 'NATURES_EMBRACE'
  AND a.description = 'Draws upon natural energy to heal and protect.';

-- Sunray: 30d10 player vs player, 20d10 otherwise.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
      ae.override_params,
      '{amount}',
      to_jsonb('roll_dice(20 + 10 * actor_is_player * target_is_player, 10) + (pow(skill, 2) * 7) / 400'::text))
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'SUNRAY'
  AND e.name = 'damage'
  AND ae.override_params->>'amount' = '20d10 + (pow(skill, 2) * 7) / 400';

-- The catalog's Sunray notes were never synced from data/abilities.json (a one-line stub); both the stub and
-- the earlier JSON text ("30d10 only in PC-vs-PC, not expressible here") become the current JSON notes.
UPDATE "Ability" a
SET notes = 'Circle 9 druid, single target. Legacy (magic.cpp mag_damage:2864, skills.cpp:1237 MAG_DAMAGE|MAG_AFFECT): fire damage 30d10 when caster and victim are both players, 20d10 otherwise (lib misc/spell_dams: pc 30d10, npc 20d10; magic.cpp:510; a charmed caster counts as a player there, not modelled) + skill^2*7/400, never saved against; then, unless the mob is NOBLIND, a WILL save negates the blinding (EFF_BLIND 2 ticks, -4 accuracy, -40 evasion). NEGATE_STATUS keeps the damage on a made save. No undead/light-sensitive bonus exists in legacy (only fire susceptibility).'
WHERE a.plain_name = 'SUNRAY'
  AND (a.notes = 'Debuff spell reducing accuracy and evasion with radiant energy.'
       OR position('30d10 only in PC-vs-PC, not expressible here' IN a.notes) > 0);
