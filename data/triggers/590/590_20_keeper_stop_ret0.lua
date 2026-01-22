-- Trigger: keeper_stop_ret0
-- Zone: 590, ID: 20
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59020

-- Converted from DG Script #59020: keeper_stop_ret0
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: op
if not (cmd == "op") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
return _return_value