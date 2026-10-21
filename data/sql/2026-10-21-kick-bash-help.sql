-- fierymud-rs #175 / #176 follow-up: the kick and bash help entries said the lag blocks every command "including
-- fleeing" and that a bash knockdown lasts "a few rounds". In fact each is a per-skill cooldown (kick 6 s, bash 8 s)
-- that only refuses that same skill; the bash victim is simply left sitting.
--
-- The HelpEntry rows come from the legacy help.hlp import (no file under fierylib/data holds them), so this patch is
-- the committed record. Keyed by keyword ({kick}, {bash}).
--
-- Idempotent: each rewrite only fires while the old wording is still in the row, so a second run changes 0 rows and
-- a builder's later edit in Muditor is never overwritten. Whitespace in the match is \s+ so line wrapping is irrelevant.

BEGIN;

UPDATE "HelpEntry"
SET content = regexp_replace(
      content,
      'whenever you KICK \(or miss\) you will\s+be unable to type any command for a short period of time so use it\s+wisely\.',
      E'whenever you KICK (or miss) you cannot KICK again\nfor 6 seconds, so use it wisely. The cooldown only affects KICK: you can\nstill fight, flee, or use any other command or skill while it runs.'),
    updated_at = now()
WHERE keywords = ARRAY['kick']
  AND content ~ 'be unable to type any command for a short period of time';

UPDATE "HelpEntry"
SET content = regexp_replace(
      content,
      'The victim will be unable to fight or issue any commands for a\s+few rounds of combat\.',
      E'The victim is left sitting and must get back on its\nfeet.'),
    updated_at = now()
WHERE keywords = ARRAY['bash']
  AND content ~ 'unable to fight or issue any commands for a\s+few rounds';

UPDATE "HelpEntry"
SET content = regexp_replace(
      content,
      'Regardless of success or failure, BASH will make you unable to type\s+commands for a couple rounds of combat, including fleeing\.',
      E'Regardless of success or failure, BASH has an 8 second cooldown: you\ncannot BASH again until it has passed. The cooldown only affects BASH, so\nyou can still fight, flee, or use any other command or skill meanwhile.'),
    updated_at = now()
WHERE keywords = ARRAY['bash']
  AND content ~ 'unable to type\s+commands for a couple rounds of combat, including fleeing';

COMMIT;
