-- PLAYER DATA. Do not apply to prod without approval.
--
-- Companion to 2026-10-12-combat-stat-scale.sql (mobs). Seeded and imported characters got evasion from
-- the 3-18 stat formula applied to the 0-100 dex scale (`50 + round(((dex - 10) // 2) * dex_evasion_mult)
-- + round(evasion_per_level * level)`), landing at 64-136 at level 1; mobs then hit players ~22% of the
-- time. This recomputes the dex term with stat_bonus(dex) = clamp(trunc((dex - 50) / 5), -10, 10)
-- (CoreStats::bonus in fierymud-rs), exactly what combat_formulas.derive_hit_roll_baseline now returns.
--
-- 1. Rebase: a character is only rewritten while its evasion still equals the OLD formula's output for its
--    own dex, level and class rates (classless characters use the 1.0 / 2.0 defaults). A trained dex, a
--    GM-edited evasion or an in-game-created character (already on the new scale) never matches and is
--    left alone. A second run changes 0 rows.
-- 2. Fill: characters created in game before fierymud-rs 8c184b1 kept the schema defaults (accuracy 0,
--    evasion 0, attack power 0) and miss almost every swing. They get the full class baseline
--    (accuracy, evasion, attack power, crit). Guarded on all three still being 0, so a second run
--    changes 0 rows.
--
-- round() on double precision is round-half-even in Postgres, like the Python importer.

WITH r AS (
    SELECT c.id,
           c.evasion AS cur,
           50 + round(floor((c.dexterity - 10) / 2.0)::float8 * COALESCE(k.dex_evasion_mult, 1.0))::int
              + round(COALESCE(k.evasion_per_level, 2.0) * c.level)::int AS old_ev,
           50 + round(LEAST(10, GREATEST(-10, trunc((c.dexterity - 50) / 5.0)))::float8
                      * COALESCE(k.dex_evasion_mult, 1.0))::int
              + round(COALESCE(k.evasion_per_level, 2.0) * c.level)::int AS new_ev
    FROM "Characters" c
    LEFT JOIN "Class" k ON k.id = c.class_id
    WHERE c.accuracy > 0
)
UPDATE "Characters" c
SET evasion = r.new_ev
FROM r
WHERE c.id = r.id
  AND c.evasion = r.old_ev
  AND r.old_ev <> r.new_ev;

WITH u AS (
    SELECT c.id,
           50 + round(COALESCE(k.accuracy_per_level, 2.0) * c.level)::int AS accuracy,
           50 + round(LEAST(10, GREATEST(-10, trunc((c.dexterity - 50) / 5.0)))::float8
                      * COALESCE(k.dex_evasion_mult, 1.0))::int
              + round(COALESCE(k.evasion_per_level, 2.0) * c.level)::int AS evasion,
           round(COALESCE(k.attack_power_per_level, 2.0) * c.level)::int AS attack_power,
           COALESCE(k.base_crit_chance, 5) AS crit_chance
    FROM "Characters" c
    LEFT JOIN "Class" k ON k.id = c.class_id
    WHERE c.accuracy = 0 AND c.evasion = 0 AND c.attack_power = 0
)
UPDATE "Characters" c
SET accuracy = u.accuracy,
    evasion = u.evasion,
    attack_power = u.attack_power,
    crit_chance = u.crit_chance
FROM u
WHERE c.id = u.id;
