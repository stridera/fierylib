-- Player house storage keeps per-instance item state (fierymud-rs).
-- A placed item used to keep only its prototype key, so an enchanted, cursed or labeled item
-- came back from the house as a plain prototype copy. player_house_items now carries the same
-- per-instance columns as "CharacterItems": custom_name (label), custom_examine_description,
-- and custom_values (already present: the `keywords` override and the `curse` key holding
-- ItemAlter -- restriction changes, Enchant Weapon applies / MAGIC flag / barred alignments).
-- Mirrors PlayerHouseItem in muditor/packages/db/prisma/schema.prisma.
--
-- Idempotent: every statement is guarded, a second run changes nothing.
ALTER TABLE player_house_items ADD COLUMN IF NOT EXISTS custom_name text;
ALTER TABLE player_house_items ADD COLUMN IF NOT EXISTS custom_examine_description text;
ALTER TABLE player_house_items ADD COLUMN IF NOT EXISTS custom_values jsonb NOT NULL DEFAULT '{}'::jsonb;
