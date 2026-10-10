-- Trigger: **UNUSED**
-- Zone: 615, ID: 39
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61539

-- Converted from DG Script #61539: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value