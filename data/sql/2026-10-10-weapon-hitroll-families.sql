-- Weapon-skill hit bonus for every weapon family (fierymud-rs `weapon_hitroll` passive).
--
-- Legacy fight.cpp calc_thaco gave every weapon user GET_SKILL(weapon_proficiency) / 2 off the
-- to-hit target (x10 scale, so skill / 20 accuracy points): the one-handed skill for a one-handed
-- weapon, the SKILL_2H_* skill for a weapon in WEAR_2HWIELD. Only Bludgeoning Weapons carried the
-- modern `weapon_hitroll` passive row, so only bludgeon users got up to +5 accuracy.
--
-- Adds the same row (skill / 20, trigger 'passive') to Slashing, Piercing and the three Two-Hand
-- weapon skills. `weapon_type` is the family the runtime matches against the wielded weapon
-- (combat.rs weapon_family / proto_weapon_family): slashing / bludgeoning / piercing for one-handed
-- weapons, two_hand_<family> for a prototype with the TWOHAND wear flag and no MAINHAND flag.
-- Source of truth: data/abilities.json (tests/test_weapon_hitroll_families.py keeps them in sync).
--
-- Keyed by Ability.plain_name (ids differ between dev and prod). A row is only added while the
-- ability has no `weapon_hitroll` modify row, so a second run changes nothing and builder edits
-- survive.
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       jsonb_build_object('type', 'passive', 'amount', 'skill / 20',
                          'target', 'weapon_hitroll', 'weapon_type', f.family),
       0, 'passive'
FROM (VALUES
  ('SLASHING', 'slashing'),
  ('PIERCING', 'piercing'),
  ('TWO_HAND_BLUDGEONING', 'two_hand_bludgeoning'),
  ('TWO_HAND_SLASHING', 'two_hand_slashing'),
  ('TWO_HAND_PIERCING', 'two_hand_piercing')
) AS f(plain_name, family)
JOIN "Ability" a ON a.plain_name = f.plain_name
JOIN "Effect" e ON e.name = 'modify'
WHERE NOT EXISTS (
  SELECT 1 FROM "AbilityEffect" x
  WHERE x.ability_id = a.id AND x.effect_id = e.id
    AND x.override_params->>'target' = 'weapon_hitroll')
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

-- Enchant Weapon: data/abilities.json already runs it as the alter_object "enchant" mode
-- (2026-10-09-enchant-weapon.sql), but databases that never ran that patch still hold the old
-- `modify` row targeting the unsupported stat key 'item_bonus', so the spell changes nothing.
-- Same three guarded statements as that patch: drop the stale row while it still targets
-- 'item_bonus', add the alter_object row, add the carried-object targeting.
UPDATE "Effect"
SET description = description || ' The enchant mode (Enchant Weapon) gives a non-magical weapon per-instance stat applies, the MAGIC flag and an anti-alignment bar.'
WHERE name = 'alter_object' AND description NOT LIKE '%enchant mode%';

DELETE FROM "AbilityEffect" ae
USING "Ability" a, "Effect" e
WHERE ae.ability_id = a.id AND ae.effect_id = e.id
  AND a.plain_name = 'ENCHANT_WEAPON'
  AND e.name = 'modify'
  AND ae.override_params->>'target' = 'item_bonus';

INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT a.id, e.id,
       '{"mode": "enchant", "requireType": "WEAPON", "setFlags": ["MAGIC"], "applies": [{"target": "accuracy", "amount": "2 + 2 * clamp(skill - 17, 0, 1)"}, {"target": "attack_power", "amount": "5 + 5 * clamp(skill - 19, 0, 1)"}], "goodCasterBars": "EVIL", "evilCasterBars": "GOOD", "messageToCasterGood": "{item} glows blue.", "messageToCasterEvil": "{item} glows red.", "messageToCasterNeutral": "{item} glows yellow."}'::jsonb,
       0, 'on_cast'
FROM "Ability" a, "Effect" e
WHERE a.plain_name = 'ENCHANT_WEAPON' AND e.name = 'alter_object'
  AND NOT EXISTS (SELECT 1 FROM "AbilityEffect" x WHERE x.ability_id = a.id AND x.effect_id = e.id)
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range)
SELECT a.id, ARRAY['OBJECT_INV']::"TargetType"[], 'SINGLE', 1, 0
FROM "Ability" a
WHERE a.plain_name = 'ENCHANT_WEAPON'
ON CONFLICT (ability_id) DO NOTHING;
