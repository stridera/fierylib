-- Trigger: flee_return0
-- Zone: 590, ID: 35
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59035

-- Converted from DG Script #59035: flee_return0
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: f
if not (cmd == "f") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value