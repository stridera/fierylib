-- fierymud-rs #137: composition-based interaction restrictions.
-- Legacy spell_suitable_for_fluid_characters(): these seven spells cannot take hold in a body that is
-- not solid (water, mist, air, fire, ether), and are stripped from one that turns fluid (Waterform,
-- Vaporform). The runtime reads the `requires_rigid` tag from Ability.tags, so builders can add or
-- drop the tag in Muditor without a recompile.
-- Idempotent: a row that already carries the tag is left alone; a NULL tags column counts as empty.
UPDATE "Ability"
SET tags = array_append(coalesce(tags, '{}'), 'requires_rigid')
WHERE plain_name IN ('STONE_SKIN', 'BARKSKIN', 'BONE_ARMOR', 'DEMONSKIN', 'GAIAS_CLOAK', 'ICE_ARMOR', 'COLDSHIELD')
  AND NOT ('requires_rigid' = ANY (coalesce(tags, '{}')));
