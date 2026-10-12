-- Trigger: no training
-- Zone: 30, ID: 155
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3155

-- Converted from DG Script #3155: no training
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Retired (fierymud-rs playtest r7 #1). Legacy FieryMUD had no practice or
-- training points: the guildmaster refused the `train` command and told the
-- player that skills grow with use. fierymud-rs spends practice points and
-- train points with a trainer or guildmaster, so the refusal would make both
-- unusable in every guild. The trigger now lets the command through.
return true
