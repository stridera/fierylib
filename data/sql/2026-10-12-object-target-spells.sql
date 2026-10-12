-- fierymud-rs: the object-target uses of twelve spells (legacy skills.cpp TAR_OBJ_*, magic.cpp mag_alter_obj, spells.cpp).
-- Before this patch these spells had no AbilityTargeting row and their effects (status / modify / room / heal / ...)
-- only acted on characters, so `cast bless sword`, `cast poison pie`, `cast preserve corpse` ... did nothing useful.
--
--   BLESS             mode flags: a plain, light, low-level weapon refuses evil wielders (legacy ITEM_ANTI_EVIL + EFF_BLESS)
--   INVISIBLE         mode flags: sets the INVISIBLE object flag unless NO_INVISIBLE / already invisible
--   DISPEL_MAGIC      mode flags: an invisible object turns visible (random(1,50) + skill must beat its level)
--   POISON            mode poison: poisons food, drink containers and fountains
--   REMOVE_POISON     mode poison (poisoned=false): purifies them
--   CREATE_WATER      mode liquid: fills a drink container (slime if it held something else)
--   PRESERVE          mode corpse_timer: a corpse in the room lasts caster-level more game hours
--   DARK_FEAST        mode corpse_feed: eating a corpse takes 24 hours off the caster's hunger and thirst
--   DARKNESS          mode light (drain): burns a light out and snuffs it
--   ILLUMINATION      mode light (ignite): refuels and lights a burnt-out light
--   ANIMATE_DEAD, SUMMON_DRACOLICH: targeting row only (the summon effect already finds the corpse in the room)
-- EARTH_BLESSING is not patched: legacy mag_alter_obj has no case for it ("Nothing seems to happen"), so its TAR_OBJ_INV
-- was a data slip with no object behaviour to port.
--
-- Each spell's character effect is untouched. Targeting rows keep SELF (and ENEMY_* where the spell is hostile) so the
-- character case resolves exactly as before. Ability.plain_name keyed. Source of truth: data/abilities.json
-- (tests/test_object_target_spells.py keeps the two in sync); the runtime side is the alter_object modes in
-- fierymud-rs crates/mud-server/src/commands/object_spell_modes.rs.
--
-- Idempotent: the alter_object row is only added to an ability that has none (builder edits survive), the targeting
-- row only to an ability that has none, and the description edits are guarded, so a second run changes 0 rows.

-- 1. The alter_object Effect documents the new modes.
UPDATE "Effect"
SET description = description || ' The flags, poison, liquid, corpse_timer, corpse_feed and light modes give Bless, Invisibility, Dispel Magic, Poison, Remove Poison, Create Water, Preserve, Dark Feast, Darkness and Illumination their object uses.'
WHERE name = 'alter_object' AND description NOT LIKE '%corpse_feed%';

-- 2. alter_object rows.

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "flags", "staffBypass": true, "requireTypes": ["WEAPON"], "wrongTypeMessage": "This spell is only effective on weapons.", "maxObjectLevel": "skill", "tooPowerfulMessage": "{item} is too powerful for you to bless.", "maxObjectWeight": "5 * skill", "tooLargeMessage": "{item} is too large for you to bless.", "blockedByFlags": ["GLOW", "HUM", "INVISIBLE", "MAGIC"], "blockedByRestrictions": ["NO_DROP"], "blockedByAlignments": ["GOOD"], "blockedMessage": "{item} doesn''t seem receptive to the blessing.", "repelledIfMagical": true, "repelledMessage": "The blessing is repelled from {item}.", "barAlignment": "EVIL", "messageToCaster": "{item} glows briefly.", "messageToRoom": "{item} glows briefly.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'BLESS' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "flags", "blockedByFlags": ["INVISIBLE"], "blockedByRestrictions": ["NO_INVISIBLE"], "setFlags": ["INVISIBLE"], "messageToCaster": "{item} vanishes.", "messageToRoom": "{item} vanishes.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'INVISIBLE' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "flags", "requireAnyFlag": ["INVISIBLE"], "powerRoll": "random(1, 50) + skill", "resistMessageToCaster": "You fail.", "clearFlags": ["INVISIBLE"], "messageToCaster": "{item} fades into existence.", "messageToRoom": "{item} fades into existence.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'DISPEL_MAGIC' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "poison", "poisoned": true, "messageToCaster": "{item} steams briefly.", "messageToRoom": "{item} steams briefly.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'POISON' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "poison", "poisoned": false, "messageToCaster": "{item} steams briefly.", "messageToRoom": "{item} steams briefly.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'REMOVE_POISON' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "liquid", "liquid": "water", "mixedLiquid": "slime-mold-juice", "amount": "1 + 15 * skill / 2", "fullMessage": "{item} seems to be full already.", "messageToCaster": "Water wells up within {item}."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'CREATE_WATER' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "corpse_timer", "hours": "level", "notCorpseMessageToCaster": "You can only preserve a corpse!", "messageToCaster": ["{item} glows <b:blue>blue</> briefly.", "{item} is preserved for {hours} more hours."], "messageToRoom": "{item} glows <b:blue>blue</> briefly."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'PRESERVE' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "corpse_feed", "hunger": 24, "thirst": 24, "notCorpseMessageToCaster": "That is not a corpse!", "messageToCaster": "<b:black>You gorge yourself on {item}.</>", "messageToRoom": "<b:black>{actor.name} gorges {actor.ref} on {item}.</>"}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'DARK_FEAST' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "light", "lightAction": "drain", "messageToCaster": "You drain {item}''s energy.", "extinguishMessageToCaster": "<b:black>{item} quickly sputters out.</>", "extinguishMessageToRoom": "<b:black>{item} quickly sputters out.</>", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'DARKNESS' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "light", "lightAction": "ignite", "capacityMultiplier": 2, "defaultFuel": 50, "permanentMessageToCaster": "The power of your magic washes uselessly over the surface of {item}.", "messageToCaster": "{item} begins glowing with a <b:yellow>bright yellow light</>.", "messageToRoom": "{item} begins glowing with a <b:yellow>bright yellow light</>.", "noopMessageToCaster": "Nothing seems to happen."}'::jsonb,
       COALESCE((SELECT MAX(x."order") FROM "AbilityEffect" x WHERE x.ability_id = a.id), -1) + 1, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'ILLUMINATION' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

-- 3. Targeting rows.

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'BLESS'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'INVISIBLE'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ENEMY_PC', 'ENEMY_NPC', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'DISPEL_MAGIC'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ENEMY_PC', 'ENEMY_NPC', 'OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'POISON'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'REMOVE_POISON'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'CREATE_WATER'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'PRESERVE'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'DARK_FEAST'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'DARKNESS'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'ILLUMINATION'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'ANIMATE_DEAD'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id, ARRAY['SELF', 'OBJECT_WORLD']::"TargetType"[], 'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'SUMMON_DRACOLICH'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);

-- 4. Bless's help text said it had no action on items.
UPDATE "Ability"
SET description = REPLACE(description, 'Bless on an item currently has no defined action.  It is only possible',
                          'Bless on a plain, light, non-magical weapon makes it refuse evil wielders.')
WHERE plain_name = 'BLESS' AND description LIKE '%Bless on an item currently has no defined action.%';
