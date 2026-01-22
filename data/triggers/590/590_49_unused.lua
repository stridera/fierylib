-- Trigger: **UNUSED**
-- Zone: 590, ID: 49
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59049

-- Converted from DG Script #59049: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: commun
if not (cmd == "commun") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value