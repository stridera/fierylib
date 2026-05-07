-- Trigger: Guard Ice Cult
-- Zone: 102, ID: 1
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10201

-- Converted from DG Script #10201: Guard Ice Cult
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
-- Block low-level players from heading west; warn them and let high-level
-- players (and non-players) pass through. Mirrors legacy DG #10201.
if actor.is_player and actor.level < 40 then
    self:whisper(actor.name, "You are much too weak to venture through this tunnel.")
    wait(1)
    self:whisper(actor.name, "Try other areas first.")
    self:command("nudge " .. tostring(actor.name))
    return false
end
return true