-- Trigger: glasscase_break_return0
-- Zone: 590, ID: 4
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59004

-- Converted from DG Script #59004: glasscase_break_return0
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: brea
if not (cmd == "brea") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- returns normal value so nothing but break glass sets trigger off
return _return_value