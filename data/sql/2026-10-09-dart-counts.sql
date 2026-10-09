-- Dart-style spells fire a skill-gated random number of bolts, and Remove Paralysis tells the caster when
-- there was nothing to lift. Both are data, read by the multihit damage / cleanse arms of fierymud-rs.
--
-- Bolt count (legacy fierymud main, spells.cpp spell_magic_missile 1280, spell_fire_darts 1321,
-- spell_ice_darts 1363, spell_spirit_arrows 1402): 1 bolt, plus one more for each tier whose skill gate is
-- met AND whose random_number(1, 100) beats its threshold. Gates / thresholds: skill >= 5 / > 80, >= 14 / > 75,
-- >= 24 / > 60, >= 34 / > 55, >= 44 / > 50, >= 74 / > 25 (Fire Darts' second gate is skill >= 12). "skill" is
-- the caster's 0-100 proficiency in the spell. The formula language has no comparisons, so each test is
-- clamp(x - (N - 1), 0, 1). This replaces the old runtime curve of 1 + (level - 1) / 2 capped at 5. The row
-- keeps the `multihit` flag; `boltCount` is the formula. Fire Darts and Spirit Arrows share the multihit arm,
-- so they get their own legacy formulas rather than dropping to a single bolt.
--
-- Remove Paralysis (spells.cpp:1878 spell_remove_paralysis): when the target had nothing to lift the caster
-- alone is told "$N can already move just fine." (or "You can already move just fine." on themselves).
-- Carried by `noopMessage` / `noopMessageSelf` on the cleanse row.
--
-- Source of truth for reimports: data/abilities.json (tests/test_dart_counts.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: each
-- statement only touches a row still missing the param, so a second run changes 0 rows and builder edits
-- made afterwards survive.

UPDATE "AbilityEffect" ae
SET override_params = ae.override_params || jsonb_build_object('boltCount', v.formula)
FROM "Ability" a, "Effect" e, (VALUES
  ('FIRE_DARTS', '1 + clamp(skill - 4, 0, 1) * clamp(random(1, 100) - 80, 0, 1) + clamp(skill - 11, 0, 1) * clamp(random(1, 100) - 75, 0, 1) + clamp(skill - 23, 0, 1) * clamp(random(1, 100) - 60, 0, 1) + clamp(skill - 33, 0, 1) * clamp(random(1, 100) - 55, 0, 1) + clamp(skill - 43, 0, 1) * clamp(random(1, 100) - 50, 0, 1) + clamp(skill - 73, 0, 1) * clamp(random(1, 100) - 25, 0, 1)'),
  ('ICE_DARTS', '1 + clamp(skill - 4, 0, 1) * clamp(random(1, 100) - 80, 0, 1) + clamp(skill - 13, 0, 1) * clamp(random(1, 100) - 75, 0, 1) + clamp(skill - 23, 0, 1) * clamp(random(1, 100) - 60, 0, 1) + clamp(skill - 33, 0, 1) * clamp(random(1, 100) - 55, 0, 1) + clamp(skill - 43, 0, 1) * clamp(random(1, 100) - 50, 0, 1) + clamp(skill - 73, 0, 1) * clamp(random(1, 100) - 25, 0, 1)'),
  ('MAGIC_MISSILE', '1 + clamp(skill - 4, 0, 1) * clamp(random(1, 100) - 80, 0, 1) + clamp(skill - 13, 0, 1) * clamp(random(1, 100) - 75, 0, 1) + clamp(skill - 23, 0, 1) * clamp(random(1, 100) - 60, 0, 1) + clamp(skill - 33, 0, 1) * clamp(random(1, 100) - 55, 0, 1) + clamp(skill - 43, 0, 1) * clamp(random(1, 100) - 50, 0, 1) + clamp(skill - 73, 0, 1) * clamp(random(1, 100) - 25, 0, 1)'),
  ('SPIRIT_ARROWS', '1 + clamp(skill - 4, 0, 1) * clamp(random(1, 100) - 80, 0, 1) + clamp(skill - 13, 0, 1) * clamp(random(1, 100) - 75, 0, 1) + clamp(skill - 23, 0, 1) * clamp(random(1, 100) - 60, 0, 1) + clamp(skill - 33, 0, 1) * clamp(random(1, 100) - 55, 0, 1) + clamp(skill - 43, 0, 1) * clamp(random(1, 100) - 50, 0, 1) + clamp(skill - 73, 0, 1) * clamp(random(1, 100) - 25, 0, 1)')
) AS v(plain_name, formula)
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = v.plain_name
  AND e.name = 'damage'
  AND ae.override_params->'multihit' = 'true'::jsonb
  AND ae.override_params->'boltCount' IS NULL;

UPDATE "AbilityEffect" ae
SET override_params = ae.override_params || jsonb_build_object(
      'noopMessage', '{target.name} can already move just fine.',
      'noopMessageSelf', 'You can already move just fine.')
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'REMOVE_PARALYSIS'
  AND e.name = 'cleanse'
  AND ae.override_params->'noopMessage' IS NULL;
