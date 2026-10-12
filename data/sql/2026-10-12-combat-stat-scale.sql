-- Playtest N1 (level-1 hit rate): mob evasion was derived with the 3-18 stat formula
-- `50 + (dex - 10) // 2 + 2 * level` applied to FieryMUD's 0-100 dex scale, so a dex-84 sparrow got
-- evasion 91 instead of ~60 and level 0-5 mobs averaged 83-94 evasion. The importer now uses
-- stat_bonus(dex) = clamp(trunc((dex - 50) / 5), -10, 10), the same curve as CoreStats::bonus in
-- fierymud-rs, giving `50 + stat_bonus(dex) + 2 * level` (combat_formulas.derive_hit_roll_baseline).
-- Accuracy, attack power and armor never involved dex, so evasion is the only mob column that moves.
--
-- A mob is only rewritten while its evasion still equals the OLD formula's output for its own dex and
-- level, so builder-edited evasion is left alone, and a second run changes 0 rows (the new value no
-- longer matches the old formula).
--
-- Player data is NOT touched here: see 2026-10-12-character-combat-stat-scale.sql, which needs approval
-- before it runs on prod.

UPDATE "Mobs"
SET evasion = 50 + LEAST(10, GREATEST(-10, trunc((dexterity - 50) / 5.0)))::int + 2 * level
WHERE evasion = 50 + floor((dexterity - 10) / 2.0)::int + 2 * level
  AND evasion <> 50 + LEAST(10, GREATEST(-10, trunc((dexterity - 50) / 5.0)))::int + 2 * level;
