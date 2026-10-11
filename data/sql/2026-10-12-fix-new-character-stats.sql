-- PROPOSED, NOT APPLIED. Review, then run per environment inside a transaction.
--
-- Characters created through the in-game creator or Muditor's web creator before the
-- stat-scale fix were rolled as 3d6 (3..18) but the game reads stats on a 0..100 scale
-- (CoreStats::bonus = (score - 50) / 5), so they carry a -8..-10 bonus on every stat.
-- Legacy-imported characters are already on 0..100 (fierylib imports natural stats
-- unchanged; legacy roll_natural_abils produces 30..100).
--
-- There is no stored original roll to recover, so this maps each stat linearly,
-- preserving the player's relative rolls: 3 -> 30, 18 -> 100 (a 3d6 average of 10.5
-- becomes 65), then clamps to the race cap (Races.max_*), as new characters are.
--
-- Affected = all six core stats within 3..18. Rows where all six are exactly 13 are the
-- schema default (test characters such as "Zz..." names, never rolled) and are skipped.
-- At 2026-10-11: prod (fierynext) had 0 affected rows; dev (fierydev) had 0 rolled rows
-- and 31 all-13 test characters.
--
-- Dry run first:
--   SELECT c.name, c.level, c.created_at, c.strength, c.intelligence, c.wisdom,
--          c.dexterity, c.constitution, c.charisma
--   FROM "Characters" c WHERE <predicate below> ORDER BY c.created_at;

BEGIN;

CREATE TEMP TABLE affected_characters AS
SELECT c.id
FROM "Characters" c
WHERE c.strength     BETWEEN 3 AND 18
  AND c.intelligence BETWEEN 3 AND 18
  AND c.wisdom       BETWEEN 3 AND 18
  AND c.dexterity    BETWEEN 3 AND 18
  AND c.constitution BETWEEN 3 AND 18
  AND c.charisma     BETWEEN 3 AND 18
  AND NOT (c.strength = 13 AND c.intelligence = 13 AND c.wisdom = 13
           AND c.dexterity = 13 AND c.constitution = 13 AND c.charisma = 13);

UPDATE "Characters" c
SET strength     = LEAST(30 + ROUND((c.strength     - 3) * 70.0 / 15)::int, r.max_strength),
    intelligence = LEAST(30 + ROUND((c.intelligence - 3) * 70.0 / 15)::int, r.max_intelligence),
    wisdom       = LEAST(30 + ROUND((c.wisdom       - 3) * 70.0 / 15)::int, r.max_wisdom),
    dexterity    = LEAST(30 + ROUND((c.dexterity    - 3) * 70.0 / 15)::int, r.max_dexterity),
    constitution = LEAST(30 + ROUND((c.constitution - 3) * 70.0 / 15)::int, r.max_constitution),
    charisma     = LEAST(30 + ROUND((c.charisma     - 3) * 70.0 / 15)::int, r.max_charisma)
FROM "Races" r
WHERE r.race = c.race
  AND c.id IN (SELECT id FROM affected_characters);

-- Expect the number of rows listed by the dry run; ROLLBACK instead if it differs.
COMMIT;
