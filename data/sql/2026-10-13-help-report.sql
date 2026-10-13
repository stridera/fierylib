-- report <player> (fierymud-rs #147): legacy do_report tells the named player, a bare report says it to the room.
--
-- Updates the built-in "Command" row `report`: usage, help_summary, help_text. Each assignment is
-- guarded on the previous shipped text, so a row a builder has since rewritten in Muditor is left
-- alone and a rerun updates nothing. The HelpEntry for REPORT already described this behaviour.
--
-- Mirrors data/command_help.json so a reseed gives the same text.
BEGIN;

UPDATE "Command"
SET usage = $h$report [<player>]$h$,
    updated_at = now()
WHERE name = 'report'
  AND usage = $h$report$h$;

UPDATE "Command"
SET help_summary = $h$Announce your HP/stamina to the room or one player.$h$,
    updated_at = now()
WHERE name = 'report'
  AND help_summary = $h$Announce your HP/stamina to your group or room.$h$;

UPDATE "Command"
SET help_text = $h$With no argument, says your hit and movement points to everyone in the room. 'report <player>' tells that player instead (only they see it, and the usual tell refusals apply). Use 'greport' to report to your whole group.$h$,
    updated_at = now()
WHERE name = 'report'
  AND help_text = $h$If you're grouped, the report goes to every group member regardless of room (useful for healers in adjacent rooms). Solo players announce to the room only.$h$;

COMMIT;
