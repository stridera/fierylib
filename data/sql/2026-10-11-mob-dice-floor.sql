-- Floor for spawned mobs that came out of the importer with no HP dice or no damage dice.
--
-- HP: 16 reset-spawned mobs (level-0 and low-level mobs whose computed HP was <= 0) were stored
-- as 0d0+0 and spawn with 0 HP. They get 1d4 + level*2 + 1, the same floor the importer now uses
-- (combat_formulas.minimum_hp_dice).
-- Damage: reset-spawned mobs whose race/class dice factor rounded the damage dice count down to
-- 0 (the min-1-die clamp ran before the factor). They get 1 die; size and bonus are untouched.
--
-- Keyed by (zone_id, id) and guarded by the current values, so a builder-edited mob is left alone
-- and a second run changes 0 rows.
UPDATE "Mobs" m
SET hp_dice_num = 1, hp_dice_size = 4, hp_dice_bonus = m.level * 2 + 1
FROM (VALUES
  (16, 2),
  (16, 89),
  (30, 208),
  (54, 3),
  (54, 4),
  (61, 26),
  (69, 8),
  (80, 0),
  (80, 1),
  (80, 2),
  (100, 51),
  (133, 14),
  (169, 0),
  (169, 7),
  (300, 81),
  (302, 5)
) AS k(zone_id, id)
WHERE m.zone_id = k.zone_id AND m.id = k.id
  AND m.hp_dice_num = 0 AND m.hp_dice_size = 0 AND m.hp_dice_bonus = 0;

UPDATE "Mobs" m
SET damage_dice_num = 1
FROM (VALUES
  (30, 61),
  (43, 0),
  (43, 1),
  (43, 4),
  (43, 9),
  (54, 14),
  (54, 47),
  (60, 31),
  (69, 4),
  (86, 7),
  (86, 9),
  (88, 9),
  (172, 2),
  (180, 1),
  (180, 2),
  (180, 5),
  (180, 7),
  (300, 52),
  (300, 54),
  (360, 1),
  (360, 2),
  (588, 8),
  (588, 9),
  (615, 0),
  (615, 7),
  (615, 8),
  (615, 14),
  (615, 25),
  (615, 26),
  (615, 28),
  (615, 50)
) AS k(zone_id, id)
WHERE m.zone_id = k.zone_id AND m.id = k.id
  AND m.damage_dice_num = 0 AND m.damage_dice_size > 0;
