-- Board privileges were imported without their rules.
--
-- The legacy board files (lib/etc/boards/*.brd) carry one rule per privilege slot:
--   privilege: 0 level 0 105     -> slot 0 (Read), level 0 to 105
-- fierylib's board_parser only understood a bare number there, so every `level X Y`
-- line was dropped and eight of the boards ended up with privileges = [] (staff-only:
-- wof1, wof2 and archive stopped being public). board_parser now keeps the rules, as
-- {"privilege": "<Read|WriteNew|RemoveOwn|EditOwn|RemoveAny|EditAny|WriteSticky|Lock>",
--  "level": <min>, "maxLevel": <max>}, which is what the C++ server's board loader reads and
-- what Muditor maps to roles (level <= 1 is public, 100+ is staff). Rules whose engine is gone
-- (wof3's clan/name rules) are kept verbatim as {"privilege": ..., "rule": "<text>"} and only staff
-- satisfy them. The mortal board's blank `privilege: 4 `..`7 ` lines (legacy: everyone) are set to
-- level 100+ so no player can pin, edit-any, remove-any or lock.
--
-- Keyed by Board.alias; boards absent from this database are skipped. Idempotent: a board is
-- touched only while its privileges differ from the legacy rules, so a second run changes 0 rows.

WITH legacy(alias, privileges) AS (
  VALUES
    ('mortal', '[{"privilege":"Read","level":0,"maxLevel":105},{"privilege":"WriteNew","level":0,"maxLevel":105},{"privilege":"RemoveOwn","level":0,"maxLevel":105},{"privilege":"EditOwn","level":0,"maxLevel":105},{"privilege":"RemoveAny","level":100,"maxLevel":105},{"privilege":"EditAny","level":100,"maxLevel":105},{"privilege":"WriteSticky","level":100,"maxLevel":105},{"privilege":"Lock","level":100,"maxLevel":105}]'::jsonb),
    ('god', '[{"privilege":"Read","level":100,"maxLevel":105},{"privilege":"WriteNew","level":100,"maxLevel":105},{"privilege":"RemoveOwn","level":100,"maxLevel":105},{"privilege":"EditOwn","level":101,"maxLevel":105},{"privilege":"RemoveAny","level":104,"maxLevel":105},{"privilege":"EditAny","level":105,"maxLevel":105},{"privilege":"WriteSticky","level":103,"maxLevel":105},{"privilege":"Lock","level":104,"maxLevel":105}]'::jsonb),
    ('quest', '[{"privilege":"Read","level":100,"maxLevel":105},{"privilege":"WriteNew","level":100,"maxLevel":105},{"privilege":"RemoveOwn","level":101,"maxLevel":105},{"privilege":"EditOwn","level":101,"maxLevel":105},{"privilege":"RemoveAny","level":103,"maxLevel":105},{"privilege":"EditAny","level":103,"maxLevel":105},{"privilege":"WriteSticky","level":104,"maxLevel":105},{"privilege":"Lock","level":104,"maxLevel":105}]'::jsonb),
    ('wof1', '[{"privilege":"Read","level":0,"maxLevel":105},{"privilege":"WriteNew","level":0,"maxLevel":105},{"privilege":"RemoveOwn","level":0,"maxLevel":105},{"privilege":"EditOwn","level":0,"maxLevel":105},{"privilege":"RemoveAny","level":0,"maxLevel":105},{"privilege":"EditAny","level":0,"maxLevel":105},{"privilege":"WriteSticky","level":0,"maxLevel":105},{"privilege":"Lock","level":0,"maxLevel":105}]'::jsonb),
    ('wof2', '[{"privilege":"Read","level":0,"maxLevel":105},{"privilege":"WriteNew","level":0,"maxLevel":105},{"privilege":"RemoveOwn","level":0,"maxLevel":105},{"privilege":"EditOwn","level":0,"maxLevel":105},{"privilege":"RemoveAny","level":0,"maxLevel":105},{"privilege":"EditAny","level":0,"maxLevel":105},{"privilege":"WriteSticky","level":0,"maxLevel":105},{"privilege":"Lock","level":0,"maxLevel":105}]'::jsonb),
    ('wof3', '[{"privilege":"Read","rule":"2 4 1"},{"privilege":"WriteNew","rule":"2 4 3"},{"privilege":"RemoveOwn","rule":"2 4 3"},{"privilege":"EditOwn","rule":"2 4 3"},{"privilege":"RemoveAny","rule":"1 janara kourrya"},{"privilege":"EditAny","rule":"1 kourrya"},{"privilege":"WriteSticky","rule":"1 janara kourrya"},{"privilege":"Lock","rule":"1 janara kourrya"}]'::jsonb),
    ('archive', '[{"privilege":"Read","level":1,"maxLevel":105},{"privilege":"WriteNew","level":105,"maxLevel":105},{"privilege":"RemoveOwn","level":105,"maxLevel":105},{"privilege":"EditOwn","level":105,"maxLevel":105},{"privilege":"RemoveAny","level":105,"maxLevel":105},{"privilege":"EditAny","level":105,"maxLevel":105},{"privilege":"WriteSticky","level":105,"maxLevel":105},{"privilege":"Lock","level":105,"maxLevel":105}]'::jsonb),
    ('code', '[{"privilege":"Read","level":100,"maxLevel":105},{"privilege":"WriteNew","level":101,"maxLevel":105},{"privilege":"RemoveOwn","level":101,"maxLevel":105},{"privilege":"EditOwn","level":101,"maxLevel":105},{"privilege":"RemoveAny","level":104,"maxLevel":105},{"privilege":"EditAny","level":104,"maxLevel":105},{"privilege":"WriteSticky","level":103,"maxLevel":105},{"privilege":"Lock","level":103,"maxLevel":105}]'::jsonb)
)
UPDATE "Board" AS b
SET privileges = legacy.privileges, updated_at = now()
FROM legacy
WHERE b.alias = legacy.alias
  AND b.privileges IS DISTINCT FROM legacy.privileges;
