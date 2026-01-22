-- Trigger: drink_fountain
-- Zone: 200, ID: 38
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #20038

-- Converted from DG Script #20038: drink_fountain
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(1)
if actor.level < 99 then
    actor:damage(50)  -- type: physical
    self.room:send_except(actor, tostring(actor.name) .. " is caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("You are caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value