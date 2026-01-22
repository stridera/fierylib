-- Trigger: stop_south_38
-- Zone: 590, ID: 15
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59015

-- Converted from DG Script #59015: stop_south_38
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.class == "Paladin" then
    _return_value = false
else
    actor:send(tostring(self.name) .. " puts a hand in your face, stopping you in your tracks.")
    self.room:send_except(actor, tostring(self.name) .. " puts a hand in " .. tostring(actor.name) .. "'s face, stopping " .. tostring(actor.object) .. " from going")
    self:move("south")
end
return _return_value