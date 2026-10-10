-- Muditor object-editor cleanup (2026-10-10). One-off, idempotent.
--
-- The object editor used to write camelCase keys into "Objects"."values"
-- (capacity, keyId, lightHours, foodHours, poisoned, spellLevel, spellName,
-- liquidCapacity, liquidType, containerFlags) while the game and fierylib use
-- the loader's keys (Capacity, Key, Remaining, Filling, Poisoned, Level,
-- Spells, Liquid, Flags). It also stored TagInput keywords as one
-- comma-joined array element (["sword, iron"]).
--
-- 1. values: each camelCase key is folded into its game key ONLY when the game
--    key is absent (an existing game key always wins), then the camelCase key
--    is removed. Keys without a game equivalent (brightness, damageDiceNum,
--    maxDexBonus, ...) are left alone.
-- 2. keywords: elements containing commas/whitespace are split into separate
--    keywords (empties dropped, duplicates removed, order kept).
--
-- Re-running is a no-op: both UPDATEs only touch rows that still match.
-- Dry run:  sed 's/^COMMIT;/ROLLBACK;/' this-file | psql -U strider -d fierydev

BEGIN;

-- 1. camelCase values keys -> game keys
UPDATE "Objects" AS o
SET "values" = f.adds || (o."values" - f.aliases),
    updated_at = now()
FROM (
    SELECT s.zone_id, s.id,
           ARRAY['capacity', 'liquidCapacity', 'keyId', 'lightHours',
                 'foodHours', 'poisoned', 'spellLevel', 'spellName',
                 'liquidType', 'containerFlags'] AS aliases,
           jsonb_strip_nulls(jsonb_build_object(
               'Capacity', COALESCE(s.v -> 'capacity', s.v -> 'liquidCapacity'),
               'Key', s.v -> 'keyId',
               'Remaining', s.v -> 'lightHours',
               'Filling', s.v -> 'foodHours',
               'Poisoned', s.v -> 'poisoned',
               'Level', s.v -> 'spellLevel',
               'Spells', CASE
                   WHEN jsonb_typeof(s.v -> 'spellName') = 'string'
                        AND btrim(s.v ->> 'spellName') <> ''
                   THEN jsonb_build_array(upper(btrim(s.v ->> 'spellName')))
               END,
               'Liquid', CASE
                   WHEN jsonb_typeof(s.v -> 'liquidType') = 'string'
                        AND btrim(s.v ->> 'liquidType') <> ''
                   THEN to_jsonb(upper(regexp_replace(s.v ->> 'liquidType', '\s+', '', 'g')))
               END,
               'Flags', CASE
                   WHEN jsonb_typeof(s.v -> 'containerFlags') = 'array'
                   THEN (
                       SELECT jsonb_agg(m.name ORDER BY e.ord)
                       FROM jsonb_array_elements_text(s.v -> 'containerFlags')
                                WITH ORDINALITY AS e(flag, ord)
                       JOIN (VALUES ('CLOSEABLE', 'Closeable'),
                                    ('PICKPROOF', 'PickProof'),
                                    ('CLOSED', 'Closed'),
                                    ('LOCKED', 'Locked')) AS m(up, name)
                         ON m.up = upper(e.flag)
                   )
               END
           )) AS adds
    FROM (
        SELECT zone_id, id, "values" AS v
        FROM "Objects"
        WHERE jsonb_typeof("values") = 'object'
          AND jsonb_exists_any("values", ARRAY['capacity', 'liquidCapacity',
                'keyId', 'lightHours', 'foodHours', 'poisoned', 'spellLevel',
                'spellName', 'liquidType', 'containerFlags'])
    ) AS s
) AS f
WHERE o.zone_id = f.zone_id
  AND o.id = f.id;

-- 2. comma-joined keyword elements -> separate keywords
UPDATE "Objects" AS o
SET keywords = k.fixed,
    updated_at = now()
FROM (
    SELECT zone_id, id, array_agg(kw ORDER BY first_pos) AS fixed
    FROM (
        SELECT zone_id, id, kw, min(pos) AS first_pos
        FROM (
            SELECT ob.zone_id, ob.id, w.kw, (e.n * 10000 + w.n) AS pos
            FROM "Objects" AS ob
            CROSS JOIN LATERAL unnest(ob.keywords) WITH ORDINALITY AS e(elem, n)
            CROSS JOIN LATERAL regexp_split_to_table(e.elem, '[,\s]+')
                       WITH ORDINALITY AS w(kw, n)
            WHERE w.kw <> ''
              AND EXISTS (SELECT 1 FROM unnest(ob.keywords) AS x(elem)
                          WHERE x.elem ~ '[,\s]')
        ) AS parts
        GROUP BY zone_id, id, kw
    ) AS uniq
    GROUP BY zone_id, id
) AS k
WHERE o.zone_id = k.zone_id
  AND o.id = k.id;

COMMIT;
