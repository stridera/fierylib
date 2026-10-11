-- fierymud-rs #131: "Replacing color codes in objects" - raw `&b&6`-style legacy colour codes in gear.
--
-- Where the codes lived (dev database, 2026-10-12):
--   * "CharacterItems".custom_name: 14,717 rows. The legacy player import stored each carried item's legacy short
--     description verbatim. Already fixed at the source (player_importer.py stores convert_legacy_colors(...), and
--     skips names equal to the prototype's) and by data/sql/2026-10-09-legacy-item-names.sql, which clears the
--     11,841 names that are just the prototype's own and converts the other 2,876. That patch is the fix for those
--     rows; apply it if it has not been run (it is idempotent). No `&` code is left afterwards.
--   * "Objects": the only text that still holds a legacy code is the examine text of 10:98 "Color Quick-Reference
--     Strip" (and 10:99, the colour book, whose `&b` / `&0` are LITERAL on purpose: the legacy text writes them
--     as `&&b` / `&&0`; 6:46 and 6:47 are map objects with a literal ampersand in "Kaas Plains & Black Lake").
--     The strip's text is `&1&&1 &b&&1&&b ...` (a colour code followed by an escaped literal), which the colour
--     converter turned into `&<red>1 ` - the tag opened AFTER the escaped `&`. The converter now flushes the
--     pending colour before an escaped literal (tests/test_color_converter.py), and this statement rewrites the
--     one affected row to what the fixed importer produces. plain_examine_description is already correct.
-- Keyed by (zone_id, id); matches only the old text, so a second run changes 0 rows.
UPDATE "Objects"
SET examine_description = $q$<red>&1 </><b:red>&1&b </><green>&2 </><b:green>&2&b </><yellow>&3 </><b:yellow>&3&b </><blue>&4 </><b:blue>&4&b </><magenta>&5 </><b:magenta>&5&b </><cyan>&6 </><b:cyan>&6&b </><white>&7 </><b:white>&7&b </>&8 <b>&8&b </><black>&9 </><b:black>&9&b</>
<red>@r </><b:red>@R   </><green>@g </><b:green>@G   </><yellow>@y </><b:yellow>@Y   </><blue>@b </><b:blue>@B   </><magenta>@m </><b:magenta>@M   </><cyan>@c </><b:cyan>@C   </><white>@w </><b:white>@W              </><b:black>@L</>$q$
WHERE zone_id = 10 AND id = 98
  AND examine_description = $q$&<red>1 &</><b:red>1&b &</><green>2 &</><b:green>2&b &</><yellow>3 &</><b:yellow>3&b &</><blue>4 &</><b:blue>4&b &</><magenta>5 &</><b:magenta>5&b &</><cyan>6 &</><b:cyan>6&b &</><white>7 &</><b:white>7&b &</>8 &<b>8&b &</><black>9 &</><b:black>9&b</> @<red>r @</><b:red>R   @</><green>g @</><b:green>G   @</><yellow>y @</><b:yellow>Y   @</><blue>b @</><b:blue>B   @</><magenta>m @</><b:magenta>M   @</><cyan>c @</><b:cyan>C   @</><white>w @</><b:white>W              @</><b:black>L</>$q$;
