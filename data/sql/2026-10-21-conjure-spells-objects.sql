-- Armor of Gaia, Flame Blade, Create Spring and Create Water did nothing when cast (fierymud-rs).
-- Their shared `create` effect had no object configured. Legacy behaviour (spells.cpp / magic.cpp):
--   FLAME_BLADE    wields object 1043 = (10, 43) if the wield hand is free, else "hands not free".
--   ARMOR_OF_GAIA  puts 1040/1041/1042 = (10, 40) body, (10, 41) arms, (10, 42) legs on the target, only into
--                  empty slots; with all three slots taken: "Your body is too encumbered to don the armor."
--   CREATE_SPRING  makes object 75 = (0, 75) (a FOUNTAIN, flagged DECOMPOSING) in the room; over
--                  shallows / water / underwater / air: "Nothing happens."
--   CREATE_WATER   fills a drink container (alter_object `liquid` mode, already configured); it never created
--                  an item, so its `create` row was dead weight and the SELF target made a bare cast succeed
--                  silently. Legacy targets an object only.
--
-- New `create` effect params read by the runtime:
--   equip           [{slot, objectZoneId, objectId}]: worn on the target, in order, into empty slots only
--   fullMessage     to the target when every `equip` slot is already taken
--   room            true: the object is made in the caster's room, not the pack
--   blockedSectors  sector names in which nothing is made; blockedMessage / blockedRoomMessage say so
-- Existing params (wield, message, roomMessage) are as for Ice Dagger / Create Food.
--
--   ARMOR_OF_GAIA is also SELF-only (legacy TAR_CHAR_ROOM | TAR_SELF_ONLY): it has no AbilityTargeting row, so one is
--   added; the runtime refuses any other target.
--
-- Keyed by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: every statement
-- is guarded with IS DISTINCT FROM, so a re-run changes 0 rows. Cast-line text is only replaced while it is
-- still the generic "You cast <spell>." placeholder, so builder edits survive.

-- 1. The conjured objects, as params merged into the existing `create` row (only when the object exists; for
--    Armor of Gaia the breastplate stands for the set).
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb) || p.params
FROM "Ability" a, "Effect" e,
     (VALUES
       ('FLAME_BLADE',
        10, 43,
        '{"objectType": "weapon", "objectZoneId": 10, "objectId": 43, "wield": true}'::jsonb),
       ('ARMOR_OF_GAIA',
        10, 40,
        '{"equip": [{"slot": "Body", "objectId": 40, "objectZoneId": 10},
                    {"slot": "Arms", "objectId": 41, "objectZoneId": 10},
                    {"slot": "Legs", "objectId": 42, "objectZoneId": 10}],
          "fullMessage": "Your body is too encumbered to don the armor."}'::jsonb),
       ('CREATE_SPRING',
        0, 75,
        '{"room": true, "objectZoneId": 0, "objectId": 75,
          "message": "<blue>A fresh clear spring of water bursts through the ground here.</>",
          "roomMessage": "<blue>A fresh clear spring of water bursts through the ground here.</>",
          "blockedSectors": ["SHALLOWS", "WATER", "UNDERWATER", "AIR"],
          "blockedMessage": "Nothing happens.",
          "blockedRoomMessage": "{actor.name} completes {actor.pos} spell, but nothing happens."}'::jsonb)
     ) AS p(plain_name, zone_id, object_id, params)
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = p.plain_name
  AND e.name = 'create'
  AND ae."order" = 0
  AND EXISTS (SELECT 1 FROM "Objects" o WHERE o.zone_id = p.zone_id AND o.id = p.object_id)
  AND ae.override_params IS DISTINCT FROM (COALESCE(ae.override_params, '{}'::jsonb) || p.params);

-- 2. The cast lines (the legacy act() text) for the two conjure-and-wear spells. Create Spring's lines are
--    the effect's own `message` / `roomMessage` above.
UPDATE "AbilityMessages" m
SET success_to_caster = t.to_caster,
    success_to_room = t.to_room
FROM "Ability" a,
     (VALUES
       ('FLAME_BLADE',
        '<b:red>You summon a blade of </><red>pure flame</><b:red> to aid you.</>',
        '<b:red>{actor.name} summons a blade of </><red>pure flame</><b:red> to aid {actor.him}.</>',
        'You cast flame blade.'),
       ('ARMOR_OF_GAIA',
        '<cyan>You call upon </><b:green>Gaia</><cyan> to guard your body...</>',
        '<cyan>{actor.name} calls upon </><b:green>Gaia</><cyan> to guard {actor.pos} body...</>',
        'You cast armor of gaia.')
     ) AS t(plain_name, to_caster, to_room, placeholder)
WHERE m.ability_id = a.id
  AND a.plain_name = t.plain_name
  AND m.success_to_caster = t.placeholder
  AND (m.success_to_caster IS DISTINCT FROM t.to_caster OR m.success_to_room IS DISTINCT FROM t.to_room);

-- 3. Create Water: only a drink container is a target, and the dead `create` row goes. The cast with no
--    container now says "That's not a valid target for this ability." instead of silently "succeeding".
UPDATE "AbilityTargeting" t
SET valid_targets = ARRAY['OBJECT_INV']::"TargetType"[]
FROM "Ability" a
WHERE t.ability_id = a.id
  AND a.plain_name = 'CREATE_WATER'
  AND t.valid_targets IS DISTINCT FROM ARRAY['OBJECT_INV']::"TargetType"[];

DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'CREATE_WATER'
  AND e.name = 'create'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'objectId');

-- 4. Armor of Gaia is self-only (see the header). Insert the targeting row, or narrow an existing one.
INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'ARMOR_OF_GAIA'
ON CONFLICT (ability_id) DO UPDATE
SET valid_targets = EXCLUDED.valid_targets
WHERE "AbilityTargeting".valid_targets IS DISTINCT FROM EXCLUDED.valid_targets;
