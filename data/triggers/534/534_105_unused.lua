-- Trigger: **UNUSED**
-- Zone: 534, ID: 105
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53505

-- Converted from DG Script #53505: **UNUSED**
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: u
if not (cmd == "u") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value