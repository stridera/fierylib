-- Trigger: Red_wall
-- Zone: 125, ID: 13
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12513

-- Converted from DG Script #12513: Red_wall
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
local which = random(1, 10)
if which == 4 then
    actor:send("You feel a burning sensation, but push through!")
    self.room:send_except(actor, tostring(actor.name) .. " pushes through the red field!")
    actor:teleport(get_room(126, 8))
    actor:command("look")
else
    actor:damage(75)  -- type: fire
    if damage_dealt == 0 then
        _return_value = false
    else
        -- TODO(parity): on damage hit, original sets _return_value=true (allow default west).
        -- That contradicts the flavor message ("forced back"). Confirm legacy intent.
        _return_value = true
        actor:send("The red field burns you, and you are forced back! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is forced back by the red field. (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end
return _return_value