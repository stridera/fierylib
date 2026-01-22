-- Trigger: Rent block for inn bar
-- Zone: 30, ID: 20
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3020

-- Converted from DG Script #3020: Rent block for inn bar
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rent
if not (cmd == "rent") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "r" or cmd == "re" then
    _return_value = false
    return _return_value
end
actor:send(self.name .. " tells you, '" .. "If you want to rent a room, please go upstairs to the Reception Area." .. "'")
return _return_value