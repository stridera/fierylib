-- Trigger: Bash_door
-- Zone: 490, ID: 101
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49101

-- Converted from DG Script #49101: Bash_door
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: doorbash
if not (cmd == "doorbash") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
return _return_value