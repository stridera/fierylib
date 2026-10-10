-- Trigger: vampiric_bite
-- Zone: 188, ID: 85
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18885

-- Converted from DG Script #18885: vampiric_bite
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: bite
if not (cmd == "bite") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "b" then
    _return_value = true
    return _return_value
end
if arg == "self" or arg.name == actor.name then
    _return_value = true
elseif arg and arg.room == actor.room then
    actor:send("You bite " .. tostring(arg.name) .. " on the neck!")
    actor:teleport(get_room(11, 0))
    self.room:send_except(arg, tostring(actor.name) .. " bites " .. tostring(arg.name) .. " on the neck!")
    actor:teleport(arg.room)
    arg:send(tostring(actor.name) .. " bites you on the neck!")
    _return_value = false
else
    _return_value = true
end
return _return_value