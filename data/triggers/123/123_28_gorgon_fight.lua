-- Trigger: gorgon_fight
-- Zone: 123, ID: 28
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #12328

-- Converted from DG Script #12328: gorgon_fight
-- Original: MOB trigger, flags: FIGHT, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
wait(2)
self.room:send("A gorgon exhales a cloud of <cyan>paralyzing gas!</>")
local room = self.room
local person = room.people
while person do
    if person.id == -1 then
        spells.cast(self, "major paralysis", person, 2)
    end
    local person = person.next_in_room
end