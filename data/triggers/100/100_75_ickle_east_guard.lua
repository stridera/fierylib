-- Trigger: Ickle East Guard
-- Zone: 100, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10075

-- Converted from DG Script #10075: Ickle East Guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
-- Block low-level players from heading east; warn them and let high-level
-- players (and non-players) pass through. Mirrors legacy DG #10075.
if actor.is_player and actor.level < 20 then
    self:whisper(actor.name, "You are much too little to venture east of here.")
    wait(1)
    self:whisper(actor.name, "Try other areas first.")
    self:command("nudge " .. tostring(actor.name))
    return false
end
return true