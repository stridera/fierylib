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
for _, person in ipairs(room:get_people()) do
    if person.is_player then
        spells.cast(self, "major paralysis", person, 2)
    end
end