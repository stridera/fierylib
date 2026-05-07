-- Trigger: leading_player
-- Zone: 43, ID: 98
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #4398

-- Converted from DG Script #4398: leading_player
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:send("The players CHEER madly!!")
wait(5)
self.room:send("Turning to you, the Leading Player gestures to the burning wreckage of the fire box.")
self.room:send("The Leading Player grins evilly.")
wait(4)
self.room:send("The Leading Player winks as he says, 'You're one of us now kid, part of the troupe.'")
wait(3)
self.room:send("The Leading Player summons the burning wreckage together, creating a small burning circle.")
wait(2)
self.room:send("It hovers in his outstretched hand for a moment before he lowers his hand, leaving it suspended in the air.")
wait(4)
self.room:send("The Leading Player says, 'My gift to you,' as he turns to leave.")
local person = self.people
while person do
    if person:get_quest_stage("theatre") >= 7 then
        self.room:spawn_object(43, 19)
        person:set_quest_var("theatre", "fire_ring", 1)
        person:complete_quest("theatre")
        person:command("get fire-ring")
    end
    person = person.next_in_room
end
wait(4)
self.room:send("The Leading Player blows a kiss over his shoulder and slinks off into the shadows.")
wait(8)
self.room:send("One by one the other players follow, slipping off into the theater.")
wait(6)
self.room:send("You blink and the theater has returned to normal.")
-- TODO(parity): original DG used vnum 1100 for the leading-player holding room
-- and 4399 for the leading-player mob. Verify (11, 0) is the right composite for
-- the holding room and that find_player can locate the leading-player mob there.
local holding = get_room(11, 0)
if holding and holding:find_actor("leading-player") then
    holding:at(function()
        find_player("leading-player"):teleport(get_room(43, 33))
    end)
end