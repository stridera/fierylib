-- "Command" rows that are only aliases of another command in the game registry
-- (data/command_help.json): affects -> effects, invis -> wizinvis, pray -> memorize,
-- trip -> tripup. The game resolves the alias to the canonical command, so the alias rows'
-- help columns are never read and they only show up as duplicates in Muditor.
--
-- Nothing references "Command" by foreign key (checked in pg_constraint; only
-- Command.ability_id points out, to "Ability"), so the alias rows are deleted.
--   * Permissions on an alias row are merged onto the canonical row first (invis has
--     INVISIBLE; wizinvis gets it) so no access rule is lost.
--   * The alias name is added to the canonical row's aliases when missing (pray on memorize).
--   * Rows are only deleted when the canonical row exists; a rerun finds nothing to change.
-- CommandSeeder no longer creates the alias rows (it seeds wizinvis with INVISIBLE instead of
-- invis), so a fresh import does not bring them back.
BEGIN;

CREATE TEMP TABLE _cmd_alias (alias text, canonical text) ON COMMIT DROP;
INSERT INTO _cmd_alias VALUES
  ('affects', 'effects'), ('invis', 'wizinvis'), ('pray', 'memorize'), ('trip', 'tripup');

UPDATE "Command" c
SET permissions = (
      SELECT COALESCE(array_agg(DISTINCT p ORDER BY p), ARRAY[]::"Permission"[])
      FROM unnest(c.permissions || a.permissions) AS p),
    updated_at = now()
FROM _cmd_alias m
JOIN "Command" a ON a.name = m.alias
WHERE c.name = m.canonical
  AND NOT (a.permissions <@ c.permissions);

UPDATE "Command" c
SET aliases = c.aliases || m.alias,
    updated_at = now()
FROM _cmd_alias m
JOIN "Command" a ON a.name = m.alias
WHERE c.name = m.canonical
  AND NOT (m.alias = ANY(c.aliases));

DELETE FROM "Command" a
USING _cmd_alias m
WHERE a.name = m.alias
  AND EXISTS (SELECT 1 FROM "Command" c WHERE c.name = m.canonical);

COMMIT;
