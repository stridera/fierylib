-- War Cry (legacy CHANT_WAR_CRY): a non-violent group buff, not an on-hit damage effect.
-- Legacy (fierymud main): skills.cpp:1525 chanto(CHANT_WAR_CRY, TAR_IGNORE, violent=false, MAG_GROUP) and class.cpp:2180
-- (monk, level 90). mag_group (magic.cpp:3451) -> perform_mag_group (magic.cpp:3430) -> mag_affect (magic.cpp:3206) on every
-- grouped player in the room, caster last: APPLY_HITROLL and APPLY_DAMROLL, each skill / 25 + 1, duration skill / 25 + 1
-- ticks (hours). Messages: "You feel more determined than ever!" / "$N looks more determined than ever!", wear-off
-- "Your determination level returns to normal.".
-- The dev/prod row was a violent placeholder: an on_hit physical damage effect (amount = skill) with a WILL save for half
-- damage, which made group targeting hit the group (so 2026-10-09-group-targeting.sql left it alone). Now:
--   * Ability: violent=false, is_area=true, target_scope ROOM_ALLIES (caster plus grouped players in the room);
--   * effects: modify accuracy (skill / 25 + 1) * 2 and modify attack_power (skill / 25 + 1) * 5 (hitroll x2 and damroll x5,
--     the importer's legacy conversion factors), both for skill / 25 + 1 hours, on cast; the damage row and the save go;
--   * messages as above. The group requirement is 2026-10-09-group-required.sql.
-- Source of truth for reimports: data/abilities.json (tests/test_war_cry.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: every statement is
-- guarded on the old shape, so a second run changes 0 rows and builder edits made afterwards survive.

UPDATE "Ability" a
SET violent = false,
    is_area = true,
    target_scope = 'ROOM_ALLIES',
    description = 'A monk''s chant that incites the blood of everyone grouped with the monk in the room, the monk included. Each gains <b:red>accuracy</> and <b:red>attack power</> for a few hours, more with proficiency. It is not an attack, and it cannot be chanted outside a group.',
    tags = ARRAY['monk','ki','buff','group'],
    notes = 'Legacy CHANT_WAR_CRY (skills.cpp:1525 chanto, TAR_IGNORE, not violent, MAG_GROUP; class.cpp:2180 monk level 90). mag_group (magic.cpp:3451) runs perform_mag_group (magic.cpp:3430) -> mag_affect (magic.cpp:3206) on every grouped player in the room, caster last: APPLY_HITROLL and APPLY_DAMROLL, each skill / 25 + 1, for skill / 25 + 1 ticks (hours). Hitroll converts to accuracy x2 and damroll to attack_power x5 (the importer''s legacy factors), so the rows are (skill / 25 + 1) * 2 and (skill / 25 + 1) * 5. Group targeting is targetScope ROOM_ALLIES (isArea, not violent); the group requirement is the ''grouped'' restriction rule (spell_parser.cpp:1068: "You can''t chant this song if you''re not in a group!"). This replaces the old placeholder, a violent on-hit damage effect with a WILL save.'
WHERE a.plain_name = 'WAR_CRY'
  AND a.violent;

DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'WAR_CRY'
  AND e.name = 'damage'
  AND ae.trigger = 'on_hit';

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger, chance_pct)
SELECT a.id, e.id, r.params::jsonb, r.ord, 'on_cast', 100
FROM "Ability" a
JOIN "Effect" e ON e.name = 'modify'
CROSS JOIN (VALUES
  ('{"amount": "(skill / 25 + 1) * 2", "duration": "skill / 25 + 1", "target": "accuracy", "durationUnit": "hours"}', 0, 'accuracy'),
  ('{"amount": "(skill / 25 + 1) * 5", "duration": "skill / 25 + 1", "target": "attack_power", "durationUnit": "hours"}', 1, 'attack_power')
) AS r(params, ord, target)
WHERE a.plain_name = 'WAR_CRY'
  AND NOT EXISTS (
    SELECT 1 FROM "AbilityEffect" x
    WHERE x.ability_id = a.id AND x.effect_id = e.id
      AND x.override_params->>'target' = r.target)
ON CONFLICT DO NOTHING;

DELETE FROM "AbilitySavingThrow" s
USING "Ability" a
WHERE s.ability_id = a.id
  AND a.plain_name = 'WAR_CRY'
  AND s.on_save_action = '"HALF_DAMAGE"';

UPDATE "AbilityMessages" m
SET success_to_caster = NULL,
    success_to_victim = 'You feel more determined than ever!',
    success_to_room = '{target.name} looks more determined than ever!',
    success_to_self = 'You feel more determined than ever!',
    success_self_room = '{actor.name} looks more determined than ever!',
    wearoff_to_target = 'Your determination level returns to normal.',
    wearoff_to_room = NULL
FROM "Ability" a
WHERE m.ability_id = a.id
  AND a.plain_name = 'WAR_CRY'
  AND m.success_to_caster = 'You begin chanting War Cry, your voice resonating with power!';
