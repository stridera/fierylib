-- Mark passive abilities (skills used automatically; legacy has no player command for them) with
-- the 'passive' tag. fierymud-rs reads Ability.tags containing 'passive' -> GMCP Char.Skills
-- passive: true, so clients stop rendering them as buttons (stridera/fierymud-rs#27).
-- Source of truth: data/abilities.json (tests/test_passive_ability_tags.py keeps them in sync).
--
-- Idempotent: the NOT ('passive' = ANY(tags)) guard makes a second run update 0 rows.
UPDATE "Ability"
SET tags = array_append(COALESCE(tags, ARRAY[]::text[]), 'passive')
WHERE plain_name = ANY(ARRAY[
  'AWARE',
  'BAREHAND',
  'BLUDGEONING',
  'DODGE',
  'DOUBLE_ATTACK',
  'DUAL_WIELD',
  'INSTANT_KILL',
  'KNOW_SPELL',
  'PARRY',
  'PIERCING',
  'QUICK_CHANT',
  'RIDING',
  'RIPOSTE',
  'SAFEFALL',
  'SLASHING',
  'SNEAK_ATTACK',
  'SPHERE_AIR',
  'SPHERE_DEATH',
  'SPHERE_DIVINATION',
  'SPHERE_EARTH',
  'SPHERE_ENCHANTMENT',
  'SPHERE_FIRE',
  'SPHERE_GENERIC',
  'SPHERE_HEALING',
  'SPHERE_PROTECTION',
  'SPHERE_SUMMON',
  'SPHERE_WATER',
  'STEALTH',
  'TWO_HAND_BLUDGEONING',
  'TWO_HAND_PIERCING',
  'TWO_HAND_SLASHING'
])
  AND NOT ('passive' = ANY(COALESCE(tags, ARRAY[]::text[])));
