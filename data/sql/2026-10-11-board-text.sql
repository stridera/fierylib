-- Bulletin board 30:99 (#3099) described commands that do not exist (playtest 2026-10-11 round 2
-- #66): `remove <n>` -> "You aren't wearing '1'", `write board <subject>` -> "You can't write on a
-- bulletin board". The real commands (fierymud-rs commands/boards.rs) are `look board`, `read <n>`,
-- `post` (opens a draft: first line is the subject) and `delpost <alias> <n>`; the board's alias is
-- `mortal`. The plain_* column carries no angle-bracket placeholders because strip_markup removes them.
--
-- Guarded on the legacy text, so an edited object is left alone and a second run changes 0 rows.
UPDATE "Objects"
   SET examine_description = $t$Use "look board" to see a listing of the messages. Use "read 3" (or any message number) to read a message, "post" to write a new one, and "delpost mortal 3" to remove one of your own.$t$,
       plain_examine_description = $t$Use "look board" to see a listing of the messages. Use "read 3" (or any message number) to read a message, "post" to write a new one, and "delpost mortal 3" to remove one of your own.$t$,
       updated_at = now()
 WHERE zone_id = 30 AND id = 99
   AND examine_description = $t$Use "look board" to see a listing of the messages. Use "read <message number>" or "remove <message number>" to read or remove a message, respectively.  Use "write board <subject>" to post.$t$;
