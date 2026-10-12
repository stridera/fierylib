-- fierymud-rs round-4 review: IDENTIFY had no AbilityTargeting row, so `cast identify sword` on an item lying in the
-- room refused (the no-row fallback only reaches carried items). Legacy skills.cpp: identify is
-- TAR_CHAR_ROOM | TAR_OBJ_INV | TAR_OBJ_ROOM | TAR_CONTACT. data/abilities.json now carries the targeting block
-- (same shape as REMOVE_CURSE); this patch applies it to a live DB without a re-import.
-- Keyed by Ability.plain_name. Inserts only when the ability has no row, so a second run changes 0 rows.
-- Other object-target spells without a row (BLESS, INVISIBLE, DISPEL_MAGIC, ANIMATE_DEAD, PRESERVE, ...) are left
-- alone: their runtime effects (status / modify / summon) do not act on objects yet, so a row would only misroute.
INSERT INTO "AbilityTargeting" (ability_id, valid_targets, scope, max_targets, range, require_los)
SELECT a.id,
       ARRAY['SELF', 'ALLY_PC', 'ALLY_NPC', 'OBJECT_INV', 'OBJECT_WORLD']::"TargetType"[],
       'SINGLE', 1, 0, false
FROM "Ability" a
WHERE a.plain_name = 'IDENTIFY'
  AND NOT EXISTS (SELECT 1 FROM "AbilityTargeting" t WHERE t.ability_id = a.id);
