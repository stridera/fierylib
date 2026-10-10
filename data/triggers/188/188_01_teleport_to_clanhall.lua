-- Trigger: Teleport_to_clanhall
-- Zone: 188, ID: 1
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18801

-- Converted from DG Script #18801: Teleport_to_clanhall
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: sneak
if not (cmd == "sneak") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if arg == "out" then
    if actor.room ~= 18800 then
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " ducks quietly out of the room.")
        actor:send("Glancing around, you duck quietly out of the room.")
        actor:teleport(get_room(188, 0))
        self.room:send_except(actor, tostring(actor.name) .. " suddenly fades into existance, walking in from the east.")
        actor:command("look")
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value