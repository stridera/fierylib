-- Trigger: non_clerics_out
-- Zone: 510, ID: 6
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #51006

-- Converted from DG Script #51006: non_clerics_out
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self.people then
    local rnd = room.actors[random(1, #room.actors)]
    if (rnd.room == self.id) and (rnd.id == -1) and (rnd.level < 100) and not (string.find(rnd.class, "Cleric") or string.find(rnd.class, "Priest")) then
        rnd:send("You feel a force pushing you out of the room - you are powerless to resist!")
        self.room:send_except(rnd, tostring(rnd.name) .. " suddenly starts moving out of the room.")
        rnd:teleport(get_room(510, 50))
        rnd:send("You seem to hear a voice whisper, 'This room is not for you.'")
        wait(8)
        -- rnd looks around
    end
end