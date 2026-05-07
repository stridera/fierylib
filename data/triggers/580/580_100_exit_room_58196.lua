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
-- TODO: legacy `running` global pattern is broken by the converter --
-- the outer test `if not running then` reads a non-existent local, then
-- a fresh `local running = 1` shadows the read, so `globals.running` is
-- set but never consulted on the next entry. Rewrite as e.g.
--   if globals.running then return end
--   globals.running = true
--   ...
--   globals.running = nil
-- TODO: companion trigger 580_101 listens on SPEECH for "kannon"; the
-- pair should share the same gate so "speak the name" actually works.
if direction == "north" then
    if not running then
        local running = 1
        globals.running = globals.running or true
        wait(1)
        local rnd = room.actors[random(1, #room.actors)]
        rnd:send("An image of a goddess appears before you for a second - she holds her hands out to you.")
        wait(1)
        rnd:send("The goddess says, 'Speak my name to leave this room, Yajiro was ever the joker...'")
        wait(1)
        rnd:send("The goddess gets enfolded into a large pearl then suddenly she disappears.")
        running = nil
    end
end