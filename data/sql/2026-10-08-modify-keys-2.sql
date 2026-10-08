-- Second pass over modify-effect stat keys (follows 2026-10-08-modify-stat-keys.sql). A modify effect
-- keeps its stat key in override_params->>'target'; fierymud-rs apply_modify_delta
-- (crates/mud-server/src/commands.rs) only applies the modern names, so anything else spawns a
-- labelled effect that changes nothing.
--
--   armor  -> ward          Gaia's Cloak is legacy APPLY_AC (+15 + skill/16). Armor, Barkskin, Bone Armor,
--                           Demonskin and Ice Armor, the same APPLY_AC spells, already use 'ward'
--                           (WARD_MOD_SPELLS in ability_effects_linker.py).
--   save_* -> saving_*      The old linker / convert_abilities.py emitted these; the runtime keys are
--                           saving_para / rod / petri / breath / spell. (None are in the data now;
--                           listed so a stale re-seed is repaired too.)
--
-- Keys with no runtime stat are deliberately left alone (see tests/test_modify_stat_keys.py):
-- item_bonus (Enchant Weapon), unarmed_damage (Barehand), weapon_hitroll (Bludgeoning Weapons),
-- target 'self' (Dodge / Parry) and max_mana (two worn items).
--
-- Only 'modify' effects are touched, and each row is guarded on the old key, so builder edits
-- survive and a second run updates 0 rows.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(
  ae.override_params, '{target}',
  to_jsonb(CASE ae.override_params->>'target'
    WHEN 'armor' THEN 'ward'
    WHEN 'save_para' THEN 'saving_para'
    WHEN 'save_rod' THEN 'saving_rod'
    WHEN 'save_petri' THEN 'saving_petri'
    WHEN 'save_breath' THEN 'saving_breath'
    WHEN 'save_spell' THEN 'saving_spell'
  END::text))
FROM "Effect" e
WHERE e.id = ae.effect_id
  AND e.name = 'modify'
  AND ae.override_params->>'target' IN
    ('armor', 'save_para', 'save_rod', 'save_petri', 'save_breath', 'save_spell');
