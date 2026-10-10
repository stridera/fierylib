-- Trigger: **UNUSED**
-- Zone: 188, ID: 96
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18896

-- Converted from DG Script #18896: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: t
if not (cmd == "t") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value