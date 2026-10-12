-- Legacy index/code on Liquids (data-over-code).
--
-- fierymud-rs exposed the CircleMUD liquid position to Lua (`val2` of a drink container, e.g.
-- `object.val2 == 11` for tea) from a hard-coded 42-entry array. The position now lives in
-- "Liquids".legacy_index and the object-value label ("WHISKY", "DARKALE", "FIREBRT") in
-- "Liquids".legacy_code, so a liquid added in Muditor is no longer invisible to scripts (the
-- game gives unindexed liquids a stable index after the highest legacy_index). This patch:
--   * adds both columns if missing (DDL matches Prisma's `Int?` / `String?`);
--   * fills them for the 42 legacy liquids, matched by alias, only where still NULL.
--
-- Idempotent: rerunning changes nothing.

BEGIN;

ALTER TABLE "Liquids"
    ADD COLUMN IF NOT EXISTS legacy_index INTEGER,
    ADD COLUMN IF NOT EXISTS legacy_code TEXT;

UPDATE "Liquids" AS l
SET legacy_index = COALESCE(l.legacy_index, v.idx),
    legacy_code = COALESCE(l.legacy_code, v.code),
    updated_at = now()
FROM (VALUES
    ('water', 0, 'WATER'),
    ('beer', 1, 'BEER'),
    ('wine', 2, 'WINE'),
    ('ale', 3, 'ALE'),
    ('dark-ale', 4, 'DARKALE'),
    ('whisky', 5, 'WHISKY'),
    ('lemonade', 6, 'LEMONADE'),
    ('firebreather', 7, 'FIREBRT'),
    ('local-speciality', 8, 'LOCALSPC'),
    ('slime-mold-juice', 9, 'SLIME'),
    ('milk', 10, 'MILK'),
    ('black-tea', 11, 'TEA'),
    ('coffee', 12, 'COFFEE'),
    ('blood', 13, 'BLOOD'),
    ('salt-water', 14, 'SALTWATER'),
    ('rum', 15, 'RUM'),
    ('nectar', 16, 'NECTAR'),
    ('sake', 17, 'SAKE'),
    ('cider', 18, 'CIDER'),
    ('tomato-soup', 19, 'TOMATOSOUP'),
    ('potato-soup', 20, 'POTATOSOUP'),
    ('chai', 21, 'CHAI'),
    ('apple-juice', 22, 'APPLEJUICE'),
    ('orange-juice', 23, 'ORNGJUICE'),
    ('pineapple-juice', 24, 'PNAPLJUICE'),
    ('grape-juice', 25, 'GRAPEJUICE'),
    ('pomegranate-juice', 26, 'POMJUICE'),
    ('melonade', 27, 'MELONAE'),
    ('cocoa', 28, 'COCOA'),
    ('espresso', 29, 'ESPRESSO'),
    ('cappuccino', 30, 'CAPPUCCINO'),
    ('mango-lassi', 31, 'MANGOLASSI'),
    ('rosewater', 32, 'ROSEWATER'),
    ('green-tea', 33, 'GREENTEA'),
    ('chamomile-tea', 34, 'CHAMOMILE'),
    ('gin', 35, 'GIN'),
    ('brandy', 36, 'BRANDY'),
    ('mead', 37, 'MEAD'),
    ('champagne', 38, 'CHAMPAGNE'),
    ('vodka', 39, 'VODKA'),
    ('tequila', 40, 'TEQUILA'),
    ('absinthe', 41, 'ABSINTHE')
) AS v (alias, idx, code)
WHERE l.alias = v.alias
  AND (l.legacy_index IS NULL OR l.legacy_code IS NULL);

COMMIT;
