-- Hide / Sneak tuning as data. Legacy act.other.cpp do_hide() and act.movement.cpp do_simple_move():
--   hiddenness = random(lower, upper) + stat_bonus[DEX].rogue_skills            (do_hide)
--     lower = -0.0008*s^3 + 0.1668*s^2 - 3.225*s       upper = s * (3*DEX + INT) / 40      (s = hide skill 0..100)
--     a halfling hiding in a group multiplies the DEX bonus by (level / 30 + 1)
--     WAIT_STATE: PULSE_VIOLENCE (40 ticks), half of it (20) for a thief
--     EFF_STEALTH is set when the stealth skill beats random(0, 101)
--   each move while hidden or sneaking (do_simple_move):
--     sneaking player: hiddenness -= random(2, 5)
--     otherwise:       hiddenness -= level / 2 when random(1, 101) > sneak skill + DEX bonus + 15
-- The runtime (fierymud-rs src/hiding.rs) reads the "hide" / "sneak" objects from the status
-- AbilityEffect's override_params and falls back to these same values for any key left out.
-- Source of truth for reimports: data/abilities.json (HIDE and SNEAK status effect params).
--
-- Keyed by Ability.plain_name only: Ability ids differ between dev and prod.
--
-- Idempotent: each row is only touched while it has no "hide" / "sneak" key, so a second run
-- updates 0 rows and later builder edits to the numbers survive.
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
    || '{"hide": {"lowerCubic": -0.0008, "lowerQuadratic": 0.1668, "lowerLinear": -3.225, "dexWeight": 3, "intWeight": 1, "divisor": 40, "waitTicks": 40, "thiefWaitTicks": 20, "halflingGroupLevelDivisor": 30, "stealthRollMax": 101}}'::jsonb
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'HIDE'
  AND e.name = 'status'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'hide');

UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
    || '{"sneak": {"decayMin": 2, "decayMax": 5, "failBase": 15, "levelDivisor": 2}}'::jsonb
FROM "Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = 'SNEAK'
  AND e.name = 'status'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'sneak');
