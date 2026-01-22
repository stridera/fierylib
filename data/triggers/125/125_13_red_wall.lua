-- Trigger: Red_wall
-- Zone: 125, ID: 13
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12513

-- Converted from DG Script #12513: Red_wall
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
local which = random(1, 10)
if which == 4 then
    actor:send("You feel a burning sensation, but push through!")
    self.room:send_except(actor, tostring(actor.name) .. " pushes through the red field!")
    actor:teleport(get_room(126, 8))
    actor:command("look")
else
    actor:damage(75)  -- type: fire
    if damage_dealt == 0 then
        _return_value = true
    else
        _return_value = false
        actor:send("The red field burns you, and you are forced back! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is forced back by the red field. (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end
return _return_value