-- Trigger: exit_room_58196
-- Zone: 581, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #58100

-- Converted from DG Script #58100: exit_room_58196
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
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
        rnd:send("The goddess gets enfolded into a large pearl and then suddenly she disappears.")
        running = nil
    end
end