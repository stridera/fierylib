-- Trigger: guard_block_cell
-- Zone: 200, ID: 37
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #20037

-- Converted from DG Script #20037: guard_block_cell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
self:command("frown")
self:emote("spreads out his arms and blocks your way.")
self:say("What do you think your doing?")