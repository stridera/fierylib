-- Trigger: **UNUSED**
-- Zone: 534, ID: 17
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53417

-- Converted from DG Script #53417: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: sh
if not (cmd == "sh") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value