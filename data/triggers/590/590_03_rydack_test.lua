-- Trigger: Rydack_test
-- Zone: 590, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59003

-- Converted from DG Script #59003: Rydack_test
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: fire
if not (cmd == "fire") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
if actor:get_worn("shield") ~= -1 then
    self.room:send("ok, not wearing shield")
    local shield_obj = actor:get_worn("shield")
    self.room:send(tostring(shield_obj))
end
shield_obj = nil
return _return_value