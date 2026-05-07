-- Trigger: quest_pyro_dooropen
-- Zone: 52, ID: 0
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5200
--
-- When a player tries to "search" the hidden flamewall room, the wall
-- briefly opens to the east and pulls them through to the inner sanctum.
-- "se"/"s" still pass through unmodified.

-- Command filter: search (allow shortcuts that are also valid moves)
if cmd ~= "search" then
    return true
end
if cmd == "s" or cmd == "se" then
    return true
end

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
actor:move("east")
wait(1)
self.room:send("The wall closes again as if it were never there.")
get_room(52, 19):exit("east"):set_state({hidden = true})
return false
