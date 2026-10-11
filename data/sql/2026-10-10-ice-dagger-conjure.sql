-- Ice Dagger (fierymud-rs): the spell was a plain damage spell ("hurl a dagger at the target"). Legacy
-- spell_ice_dagger (src/spells.cpp, TAR_IGNORE / MAG_MANUAL) conjures object 1047 (zone 10, id 47, "a dagger of
-- ice") into the caster's hands and wields it, refusing with "Your hands are not free to wield the dagger" when the
-- wield hand is taken. It sets no timer of its own; the object carries the DECOMPOSING flag, so it melts once dropped.
-- fierymud-rs now runs that through the generic "create" effect with wield=true: spawn the proto, wield it, and
-- make nothing when the hand is full. The spell is no longer violent and has no target or saving throw.
-- Keyed ONLY by Ability.plain_name, Effect.name and the object (zone, id); ids differ between dev and prod.
-- Source of truth for reimports: data/abilities.json (tests/test_ice_dagger.py keeps them in sync).
--
-- Idempotent: every statement only touches a row still in the old shape or inserts a missing row, so a second run
-- changes 0 rows and builder edits survive.

-- 1. The old damage effect goes.
DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id AND ae.effect_id = e.id
  AND a.plain_name = 'ICE_DAGGER'
  AND e.name = 'damage'
  AND ae.override_params = '{"type": "magic", "creates": true}'::jsonb;

-- 2. The conjure effect: legacy vnum 1047 = zone 10, id 47. Guarded on the proto existing so a database without
--    zone 10 is left on the old behaviour rather than pointing at nothing.
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"objectType": "weapon", "objectZoneId": 10, "objectId": 47, "wield": true}'::jsonb,
       0, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'ICE_DAGGER' AND e.name = 'create'
  AND EXISTS (SELECT 1 FROM "Objects" o WHERE o.zone_id = 10 AND o.id = 47)
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

-- 3. Not an attack any more: no hostile flag, no saving throw, new description and messages.
UPDATE "Ability" a
SET violent = false
WHERE a.plain_name = 'ICE_DAGGER' AND a.violent
  AND EXISTS (SELECT 1 FROM "AbilityEffect" ae JOIN "Effect" e ON e.id = ae.effect_id
              WHERE ae.ability_id = a.id AND e.name = 'create');

UPDATE "Ability"
SET description = 'Conjures a dagger of glimmering ice in your hand. Your wield hand must be free.'
WHERE plain_name = 'ICE_DAGGER'
  AND description = 'Conjures a razor-sharp dagger of ice to hurl at the target.';

DELETE FROM "AbilitySavingThrow" st
USING "Ability" a
WHERE st.ability_id = a.id
  AND a.plain_name = 'ICE_DAGGER'
  AND st.dc_formula = '10 + skill / 5 + max(int_bonus, wis_bonus)'
  AND EXISTS (SELECT 1 FROM "AbilityEffect" ae JOIN "Effect" e ON e.id = ae.effect_id
              WHERE ae.ability_id = a.id AND e.name = 'create');

UPDATE "AbilityMessages" m
SET success_to_caster = 'You summon a blade of glimmering ice to aid you.',
    success_to_victim = NULL,
    success_to_room = '{actor.name} summons a dagger of glimmering ice to aid {actor.him}.',
    fail_to_caster = NULL,
    fail_to_victim = NULL,
    fail_to_room = NULL
FROM "Ability" a
WHERE m.ability_id = a.id
  AND a.plain_name = 'ICE_DAGGER'
  AND m.success_to_caster = 'Your ice dagger strikes {target.him}!';
