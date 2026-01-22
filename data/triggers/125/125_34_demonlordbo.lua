-- Trigger: DemonLordBo
-- Zone: 125, ID: 34
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12534

-- Converted from DG Script #12534: DemonLordBo
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bo
if not (cmd == "bo") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value