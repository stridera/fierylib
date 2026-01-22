-- Trigger: **UNUSED**
-- Zone: 133, ID: 32
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #13332

-- Converted from DG Script #13332: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: commun
if not (cmd == "commun") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value