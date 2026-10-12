-- Playtest r7 #1: guildmaster no-practice / no-training COMMAND triggers pass the command through.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/030/030_155_no_training.lua
  (30, 155, $trig$-- Converted from DG Script #3155: no training
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Retired (fierymud-rs playtest r7 #1). Legacy FieryMUD had no practice or
-- training points: the guildmaster refused the `train` command and told the
-- player that skills grow with use. fierymud-rs spends practice points and
-- train points with a trainer or guildmaster, so the refusal would make both
-- unusable in every guild. The trigger now lets the command through.
return true$trig$, '5b3fb8ac13ee7fb21be027383558253c'),
  -- data/triggers/030/030_159_no_practice.lua
  (30, 159, $trig$-- Converted from DG Script #3159: no practice
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Retired (fierymud-rs playtest r7 #1). Legacy FieryMUD had no practice or
-- training points: the guildmaster refused the `practice` command and told the
-- player that skills grow with use. fierymud-rs spends practice points and
-- train points with a trainer or guildmaster, so the refusal would make both
-- unusable in every guild. The trigger now lets the command through.
return true$trig$, 'df87bd2f3339fbae1d9782500b97f5ab')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
