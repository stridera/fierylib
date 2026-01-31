-- Trigger: quest_pyro_dooropen
-- Zone: 52, ID: 0
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5200

-- Converted from DG Script #5200: quest_pyro_dooropen
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "se" then
    _return_value = false
    return _return_value
end
_return_value = true
actor:send("<blue>Something doesn't seem quite right here...</>")
wait(1)
actor:send("You feel a sharp gust of air suck at you as a wall to the east opens.")
self.room:send_except(actor, "A sharp gust of wind sucks around " .. tostring(actor.name) .. "'s feet.")
wait(1)
actor:send("You suddenly feel yourself being pulled into the opening!")
self.room:send_except(actor, tostring(actor.name) .. " suddenly is pulled into the opening!")
get_room(52, 20):at(function()
    self.room:send("A shift in the flamewall allows " .. tostring(actor.name) .. " to pop through.")
end)
get_room(52, 19):exit("east"):set_state({hidden = false})
actor.name:move("east")
wait(1)
self.room:send("The wall closes again as if it were never there.")
get_room(52, 19):exit("east"):set_state({hidden = true})
return _return_value