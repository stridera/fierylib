-- Trigger: Demise_AckbrinRun_Restrict
-- Zone: 432, ID: 56
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #43256

-- Converted from DG Script #43256: Demise_AckbrinRun_Restrict
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
self:command("frown")
self:say("You are not of our order.")
self:emote("folds his arms across his chest, blocking the way.")