-- Trigger: block_wield
-- Zone: 188, ID: 40
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18840

-- Converted from DG Script #18840: block_wield
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: wield
if not (cmd == "wield") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "w" then
    _return_value = true
    return _return_value
end
actor:send("You cannot wield another weapon with " .. tostring(self.shortdesc) .. "!")
return _return_value