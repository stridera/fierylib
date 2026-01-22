-- Trigger: stop_west_R69
-- Zone: 590, ID: 21
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: past.
--
-- Original DG Script: #59021

-- Converted from DG Script #59021: stop_west_R69
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.class == "Paladin" then
    _return_value = false
else
    actor:send(tostring(self.name) .. " jumps in front of you, preventing you from getting by.")
    self.room:send_except(actor, tostring(self.name) .. " jumps in front of " .. tostring(actor.name) .. ", preventing " .. tostring(actor.object) .. " from getting")
    -- UNCONVERTED: past.
end
return _return_value