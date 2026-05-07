-- Trigger: non_clerics_out
-- Zone: 510, ID: 6
-- Type: WORLD, Flags: RANDOM
--
-- Original DG Script: #51006
-- Periodically picks a random actor in the room. If they are a
-- sub-immortal player and not a Cleric/Priest, they are bounced to
-- (510, 50) with a "this room is not for you" message.

if self.actor_count == 0 then
    return true
end

local rnd = self.actors[random(1, self.actor_count)]
if not rnd or not rnd.is_player or rnd.level >= 100 then
    return true
end

if string.find(rnd.class, "Cleric") or string.find(rnd.class, "Priest") then
    return true
end

rnd:send("You feel a force pushing you out of the room - you are powerless to resist!")
self:send_except(rnd, tostring(rnd.name) .. " suddenly starts moving out of the room.")
rnd:teleport(get_room(510, 50))
rnd:send("You seem to hear a voice whisper, 'This room is not for you.'")
wait(8)
rnd:command("look")
