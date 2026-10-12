-- qstat <player> (fierymud-rs #141): staff can view another player's quests and quest variables.
--
-- Updates the built-in help for quests/qstat/qlist/questlog:
--   * "Command" row `quests`: usage, help_summary, help_text. Each assignment is guarded on the
--     previous shipped text, so a row a builder has since rewritten in Muditor is left alone and
--     a rerun updates nothing.
--   * HelpEntry "Qstat" (the legacy text, which `help qstat` shows ahead of the Command row):
--     it described a `[<quest name>]` filter and `quest mstat` that do not exist here.
--
-- Mirrors data/command_help.json so a reseed gives the same text.
BEGIN;

UPDATE "Command"
SET help_summary = $h$List your accepted quests (staff: or a player's).$h$,
    updated_at = now()
WHERE name = 'quests'
  AND help_summary = $h$List your accepted quests.$h$;

UPDATE "Command"
SET help_text = $h$In-progress quests appear first with their short description; completed/abandoned quests follow with their final status. Each in-progress quest also shows its phases + objective progress (▶ for current, ✓ for done, [N/M] for showProgress). Immortal+ may add a player's name (online or offline) to see that player's quests, including each quest's stored quest variables. A player hidden from you by wizinvis cannot be looked up.$h$,
    updated_at = now()
WHERE name = 'quests'
  AND help_text = $h$In-progress quests appear first with their short description; completed/abandoned quests follow with their final status. Each in-progress quest also shows its phases + objective progress (▶ for current, ✓ for done, [N/M] for showProgress).$h$;

UPDATE "Command"
SET usage = $h$quests [<player>]$h$,
    updated_at = now()
WHERE name = 'quests'
  AND usage = $h$quests$h$;

UPDATE "HelpEntry"
SET content = E'Usage: qstat\n       qstat <player>      (Immortal and above)\n\nWith no argument, lists your own quests: those in progress first, with their\nphases and objective progress, then the ones you have finished or dropped.\n\nImmortals and above may name a player, online or offline, to see that\nplayer''s quests the same way. Each quest also shows the quest variables\nstored for it, which is how to check where a player stands in a scripted\nquest. A player hidden from you by wizinvis cannot be looked up.\n\nQUESTS, QLIST and QUESTLOG are the same command.\n\nSee also: QUEST',
    usage = 'qstat [<player>]',
    updated_at = now()
WHERE 'qstat' = ANY(keywords)
  AND content LIKE '%quest mstat <player>%';

COMMIT;
