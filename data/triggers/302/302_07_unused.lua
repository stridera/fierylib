-- Trigger: **UNUSED**
-- Zone: 302, ID: 7
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30207

-- Converted from DG Script #30207: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: d
if not (cmd == "d") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Allows normal use of 'd' command around red leather bag (it intercepts
-- the "drag" command in trigger 30206).
-- Applied to: o30209
_return_value = false
return _return_value