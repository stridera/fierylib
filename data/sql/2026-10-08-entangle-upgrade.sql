-- Legacy SPELL_ENTANGLE (magic.cpp:1935): on a cast that gets past the save, skill >= 40 and
-- random(0,100) < 2 + skill/14 sets Major Paralysis for 2 + (skill > 95) hours instead of the
-- web. fierymud-rs (1e1b04a) reads an `upgrade` object from the status effect row's
-- "AbilityEffect".override_params (minSkill, chance formula, overriding flag / duration).
-- Source of truth: data/abilities.json (tests/test_entangle_upgrade.py keeps them in sync).
--
-- Idempotent: only writes when the `upgrade` key is absent, so builder edits survive and a second
-- run updates 0 rows.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
      COALESCE(ae.override_params, '{}'::jsonb),
      '{upgrade}',
      '{"minSkill": 40, "chance": "2 + skill / 14", "flag": "paralyzed", "duration": "2 + skill / 96"}'::jsonb)
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'ENTANGLE'
  AND ae.override_params->>'flag' = 'webbed'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'upgrade');
