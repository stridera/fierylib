-- Trigger: **UNUSED**
-- Zone: 30, ID: 113
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3113

-- Converted from DG Script #3113: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: whis
if not (cmd == "whis") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
-- This trigger forces the default action for "whis" instead of activating the
-- whistle trigger.
return _return_value