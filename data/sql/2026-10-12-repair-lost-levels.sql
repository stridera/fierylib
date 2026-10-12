-- PROPOSED repair for characters whose stored level lags the level their
-- experience implies, and for rows whose hit_points exceed hit_points_max.
-- NOT APPLIED. Player data: needs the owner's approval first.
--
-- Background (fierymud-rs fix "Persist level, max HP/stamina and combat
-- stats on save"): save_state never wrote level, hit_points_max,
-- stamina_max or the combat columns, so in-game level-ups lived in memory
-- only. On relog the row's old level was loaded and level_sweep_tick
-- replayed the level-ups from experience (re-rolling the HP dice and
-- re-granting practice points), then the result was lost again at save.
--
-- Prod audit (2026-10-12, fierynext): 22 characters are behind by 65 levels
-- in total, but every one of them is dormant (last_login 2011..2021, one
-- 2026-05-11). They are legacy imports: legacy FieryMUD made players run
-- `gain` to level, so banked XP above the next threshold is normal there.
-- None of the 37 characters that logged in since 2026-09-01 is behind.
-- Two characters have hit_points > hit_points_max (Lathyrus 1277/1072,
-- Samui 351/348): their in-game maximum grew past the stored one.
--
-- WITH THE FIX DEPLOYED THIS REPAIR IS OPTIONAL. The first login of a behind
-- character replays the missing level-ups once (random hit-dice rolls,
-- practice points granted, quest/achievement hooks fired), and the fixed
-- save then keeps the result. This script does the same arithmetic
-- deterministically and offline, so the outcome is reviewable first:
--
--   max HP    per missed level L+1..N:
--               GREATEST(1, LevelDefinition.hp_gain * Races.hp_factor / 100)
--               + Class.hp_per_level
--               + AVERAGE of the class hit dice (NdM+B -> N*(M+1)/2 + B)
--             i.e. the class HP curve with the dice at their expected value
--             instead of a roll. Replaying live would roll the dice.
--   stamina   sum of LevelDefinition.stamina_gain over the same levels
--   accuracy / evasion / attack_power
--             baseline(N) - baseline(L) with the class *_per_level rates,
--             rounded half away from zero like ClassCombatRates::baseline
--   skill_points  per level: GREATEST(1, 1 + level/10 + best of the
--             INT / WIS bonus (clamped 0..10)), as combat.rs::level_up_to
--   hit_points / stamina set to the new maxima (a level-up fully heals)
--
-- The hp > max rows cannot be reconstructed (the lost maximum is unknown);
-- the minimal consistent repair raises the maximum to the stored current HP.
--
-- Timing: apply while the game server is stopped, or at least before the
-- fixed build is started, and only for characters that are offline: a live
-- session holds its own copy and the new save would overwrite this repair.
-- Gear is NOT in these columns (the fixed save stores base values; the
-- repair works on the same base).
--
-- Usage: review the preview, then re-run with the final line changed from
-- ROLLBACK to COMMIT.
--   ssh fierymud 'bash -lc "sudo -n -u postgres psql -d fierynext -f -"' < this-file

BEGIN;

CREATE TEMP TABLE repair_plan AS
WITH base AS (
    SELECT c.id, c.name, c.level AS old_level, c.experience, c.last_login,
           c.intelligence, c.wisdom,
           COALESCE(k.hit_dice, '')               AS hit_dice,
           COALESCE(k.hp_per_level, 0)            AS hp_per_level,
           COALESCE(k.accuracy_per_level, 2.0)    AS acc_rate,
           COALESCE(k.evasion_per_level, 2.0)     AS eva_rate,
           COALESCE(k.attack_power_per_level, 2.0) AS ap_rate,
           COALESCE(r.hp_factor, 100)             AS hp_factor,
           COALESCE((SELECT max(ld.level) FROM "LevelDefinition" ld
                     WHERE ld.level <= 99
                       AND floor(ld.exp_required * COALESCE(k.exp_gain_factor, 1.0))::int
                           <= c.experience), 1) AS new_level
    FROM "Characters" c
    LEFT JOIN "Class" k ON k.id = c.class_id
    LEFT JOIN "Races" r ON r.race = c.race
    WHERE c.level < 99
),
dice AS (
    SELECT b.*,
           regexp_match(b.hit_dice, '^\s*(\d+)d(\d+)\s*([+-]\s*\d+)?\s*$') AS m
    FROM base b WHERE b.new_level > b.old_level
),
avg_dice AS (
    SELECT d.*,
           CASE WHEN d.m IS NULL THEN 0::numeric
                ELSE d.m[1]::numeric * (d.m[2]::numeric + 1) / 2
                     + COALESCE(replace(d.m[3], ' ', '')::numeric, 0)
           END AS dice_avg
    FROM dice d
),
per_level AS (
    SELECT a.id, lv.level AS gained_level,
           GREATEST(1, (ld.hp_gain * a.hp_factor) / 100) + a.hp_per_level + a.dice_avg AS hp_gain,
           ld.stamina_gain,
           -- level_up_to grants with the level the character is LEAVING
           GREATEST(1, 1 + ((lv.level - 1) / 10)
                        + GREATEST(0, LEAST(10, GREATEST(-10, (a.intelligence - 50) / 5)),
                                      LEAST(10, GREATEST(-10, (a.wisdom - 50) / 5)))) AS practice
    FROM avg_dice a
    CROSS JOIN LATERAL generate_series(a.old_level + 1, a.new_level) AS lv(level)
    JOIN "LevelDefinition" ld ON ld.level = lv.level
),
sums AS (
    SELECT id, round(sum(hp_gain))::int AS hp_add, sum(stamina_gain)::int AS stamina_add,
           sum(practice)::int AS practice_add
    FROM per_level GROUP BY id
)
SELECT a.id, a.name, a.old_level, a.new_level, a.experience, a.last_login,
       s.hp_add, s.stamina_add, s.practice_add,
       (floor(a.acc_rate * a.new_level + 0.5) - floor(a.acc_rate * a.old_level + 0.5))::int AS acc_add,
       (floor(a.eva_rate * a.new_level + 0.5) - floor(a.eva_rate * a.old_level + 0.5))::int AS eva_add,
       (floor(a.ap_rate  * a.new_level + 0.5) - floor(a.ap_rate  * a.old_level + 0.5))::int AS ap_add
FROM avg_dice a JOIN sums s USING (id);

-- Preview: who changes and by how much.
SELECT name, old_level, new_level, experience, hp_add, stamina_add, practice_add,
       acc_add, eva_add, ap_add, last_login
FROM repair_plan ORDER BY new_level - old_level DESC, name;

UPDATE "Characters" c
SET level          = p.new_level,
    hit_points_max = c.hit_points_max + p.hp_add,
    hit_points     = c.hit_points_max + p.hp_add,
    stamina_max    = c.stamina_max + p.stamina_add,
    stamina        = c.stamina_max + p.stamina_add,
    accuracy       = c.accuracy + p.acc_add,
    evasion        = c.evasion + p.eva_add,
    attack_power   = c.attack_power + p.ap_add,
    skill_points   = c.skill_points + p.practice_add
FROM repair_plan p
WHERE c.id = p.id;

-- hit_points above the stored maximum: the maximum was lost, raise it to the
-- stored current value (the smallest repair that restores hp <= max).
UPDATE "Characters"
SET hit_points_max = hit_points
WHERE hit_points > hit_points_max;

UPDATE "Characters"
SET stamina_max = stamina
WHERE stamina > stamina_max;

-- Verify nothing is left behind / inconsistent, then decide.
SELECT count(*) AS still_hp_over_max FROM "Characters" WHERE hit_points > hit_points_max;

ROLLBACK;  -- change to COMMIT once the preview is approved
