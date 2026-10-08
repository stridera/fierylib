-- Modify effects used legacy abbreviations as their stat key (override_params->>'target'); fierymud-rs
-- apply_modify_delta (crates/mud-server/src/commands.rs) only knows the full names, so e.g. Curse's
-- "acc" debuff applied nothing. Rewrite the abbreviations to the names the runtime supports.
-- Source of truth: data/abilities.json (tests/test_modify_stat_keys.py keeps it in the supported set).
--
-- Only 'modify' effects are touched, and each row is guarded on the old key, so builder edits
-- survive and a second run updates 0 rows.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
  ae.override_params, '{target}',
  to_jsonb(CASE ae.override_params->>'target'
    WHEN 'acc' THEN 'accuracy'
    WHEN 'ap' THEN 'attack_power'
    WHEN 'eva' THEN 'evasion'
    WHEN 'regen_hp' THEN 'hit_regen'
    WHEN 'save_spell' THEN 'saving_spell'
  END::text))
FROM "Effect" e
WHERE e.id = ae.effect_id
  AND e.name = 'modify'
  AND ae.override_params->>'target' IN ('acc', 'ap', 'eva', 'regen_hp', 'save_spell');
