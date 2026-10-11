-- Weapons with no damage dice and objects with negative weight.
--
-- Legacy stores 481/3 as 2d0 and 520/25 as 0d0 (a weapon that can never hurt); the importer now
-- falls back to 1d4 for any WEAPON with a zero die count or size. 117/111 (-2) and 4/5 (-5) are
-- legacy weight typos; the importer now floors weight at 0.
--
-- Keyed by (zone_id, id) and guarded by the current values, so a builder-edited object is left
-- alone and a second run changes 0 rows.
UPDATE "Objects" o
SET weapon_dice_num = 1, weapon_dice_size = 4
FROM (VALUES
  (481, 3, 2, 0),
  (520, 25, 0, 0)
) AS k(zone_id, id, num, size)
WHERE o.zone_id = k.zone_id AND o.id = k.id
  AND o.type = 'WEAPON'
  AND o.weapon_dice_num = k.num AND o.weapon_dice_size = k.size;

UPDATE "Objects" o
SET weight = 0
FROM (VALUES
  (4, 5, -5.0),
  (117, 111, -2.0)
) AS k(zone_id, id, weight)
WHERE o.zone_id = k.zone_id AND o.id = k.id
  AND o.weight = k.weight;
