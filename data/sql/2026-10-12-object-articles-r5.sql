-- Playtest round 5 N17: shop and inventory lines read "a aqua scroll of world
-- teleport". Five legacy short descriptions carry the wrong indefinite article
-- ("a" before a vowel, "an" before a consonant). Fixes name and plain_name.
-- Guarded and idempotent: every row is matched on its old text, so a second run
-- changes 0 rows. (The importer applies the same rule to new imports.)

UPDATE "Objects" SET name = 'an aqua scroll of world teleport',
       plain_name = 'an aqua scroll of world teleport', updated_at = now()
WHERE zone_id = 30 AND id = 27 AND name = 'a aqua scroll of world teleport';

UPDATE "Objects" SET name = 'an onyx-headed cane',
       plain_name = 'an onyx-headed cane', updated_at = now()
WHERE zone_id = 4 AND id = 67 AND name = 'a onyx-headed cane';

UPDATE "Objects" SET name = 'an apatite key',
       plain_name = 'an apatite key', updated_at = now()
WHERE zone_id = 590 AND id = 9 AND name = 'a apatite key';

UPDATE "Objects" SET name = 'a neon blue potion',
       plain_name = 'a neon blue potion', updated_at = now()
WHERE zone_id = 30 AND id = 238 AND name = 'an neon blue potion';

UPDATE "Objects" SET name = 'a radiant sapphire',
       plain_name = 'a radiant sapphire', updated_at = now()
WHERE zone_id = 557 AND id = 43 AND name = 'an radiant sapphire';
