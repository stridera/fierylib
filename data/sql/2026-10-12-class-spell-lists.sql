-- fierymud-rs #125: "Spell lists are bogus" - `help spell_cryomancer` listed greater waterwalk, levitate,
-- comprehend languages and strength (spells removed or replaced years ago) and left out Flood, Wall of Ice and
-- Major Globe. The class spell lists were imported verbatim from the legacy help.hlp, which is stale.
--
-- The lists are now generated from the data the game actually runs on, so they cannot drift:
--   spell_<class>  <- "ClassAbilities" (circle) + "Ability" (name; quest_only -> trailing `*`)
-- Every class that has any ClassAbilities rows gets its list. An existing entry is matched by its `spell_<class>`
-- keyword (anti-paladin also by `spell_antipaladin`) and has only `content` rewritten, keeping its keywords, title
-- and hand-written `See also:` line; a class with no entry yet (Mystic, Shaman) gets one.
--
-- The `skill_<class>` lists are deliberately NOT regenerated: they also name the skills every class shares
-- (bandage, douse, first aid, meditate, mount, riding, quick chant, scribe), which live in no per-class table, and
-- carry skill-cap notes ("track (reduced skill cap)"). ClassSkills alone would drop that information.
--
-- Keyed by keyword and class plain_name only (ids differ between databases). Idempotent: a row is rewritten only
-- when the generated text differs, so a second run changes 0 rows. Re-run it after any change to a class's spell
-- list (fierylib's help import runs it too: src/fierylib/importers/help_importer.py).
DO $do$
DECLARE
  c record;
  keys text[];
  header text;
  lists text;
  see_also text;
  body text;
  h record;
  found boolean;
BEGIN
  FOR c IN
    SELECT id, plain_name, lower(plain_name) AS key, is_subclass FROM "Class" ORDER BY id
  LOOP
    SELECT string_agg(g.block, E'\n\n' ORDER BY g.circle) INTO lists FROM (
      SELECT ca.circle,
             '<b:blue>Circle ' || ca.circle || ':</>' || E'\n' ||
             string_agg(lower(a.name) || CASE WHEN a.quest_only THEN '*' ELSE '' END, E'\n' ORDER BY lower(a.name)) AS block
      FROM "ClassAbilities" ca
      JOIN "Ability" a ON a.id = ca.ability_id
      WHERE ca.class_id = c.id
      GROUP BY ca.circle
    ) g;
    CONTINUE WHEN lists IS NULL;

    header := 'This is the current list and placement of ' || c.key || E' spells.\n' ||
              E'Quest spells are marked with an asterisk (*).' ||
              CASE WHEN c.is_subclass THEN ''
                   ELSE E'\nSubclasses may have different spells or the same spells in different circles.' END;
    see_also := 'See also: SKILL_' || upper(replace(c.key, '-', '_')) || ', QUEST_SPELLS, SPELL_CIRCLE';

    keys := ARRAY['spell_' || c.key];
    IF position('-' IN c.key) > 0 THEN
      keys := keys || ('spell_' || replace(c.key, '-', ''));
    END IF;

    found := false;
    FOR h IN SELECT id, content FROM "HelpEntry" WHERE keywords && keys ORDER BY id LOOP
      found := true;
      body := header || E'\n\n' || lists || E'\n\n' ||
              coalesce((regexp_match(h.content, '^See also:[^\n]*$', 'n'))[1], see_also);
      UPDATE "HelpEntry" SET content = body, updated_at = now()
      WHERE id = h.id AND content IS DISTINCT FROM body;
    END LOOP;

    IF NOT found THEN
      body := header || E'\n\n' || lists || E'\n\n' || see_also;
      INSERT INTO "HelpEntry" (keywords, title, content, min_level, category, source_file, updated_at)
      VALUES (ARRAY[c.key || ' spells', 'spell_' || c.key], c.plain_name || ' Spells',
              body, 0, 'reference', 'generated:class-help', now());
    END IF;
  END LOOP;
END
$do$;
