-- Trigger: **UNUSED**
-- Zone: 60, ID: 69
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6069

-- Converted from DG Script #6069: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: for
if not (cmd == "for") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value