-- Trigger: exit_room_58196
-- Zone: 580, ID: 100
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--
-- When someone tries to leave room 58196 to the north, a brief vision
-- of Kannon appears and tells the player they must speak her name to
-- escape. The vision is gated behind a "running" guard so the cinematic
-- only plays once at a time.
--
-- `running` is a DG global kept in this room's `globals`; it gates the cinematic so it plays once
-- at a time. (580_101 listens for the name separately and needs no shared state.)
if direction == "north" then
    if not globals.running then
        globals.running = 1
        wait(1)
        local rnd = self.room.actors[random(1, #self.room.actors)]
        rnd:send("An image of a goddess appears before you for a second - she holds her hands out to you.")
        wait(1)
        rnd:send("The goddess says, 'Speak my name to leave this room, Yajiro was ever the joker...'")
        wait(1)
        rnd:send("The goddess gets enfolded into a large pearl then suddenly she disappears.")
        globals.running = nil
    end
end