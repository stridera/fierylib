-- Trigger: faerie_dragon_fight
-- Zone: 123, ID: 31
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #12331

-- Converted from DG Script #12331: faerie_dragon_fight
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
wait(2)
self.room:send("A faerie dragon exhales a cloud of <red>e<b:yellow>u<red>p<green>h<blue>o<cyan>r<magenta>i</><red>c</> gas!")
local room = self.room
local person = room.people
while person do
    if person.id == -1 then
        spells.cast(self, "confusion", person, self.level)
    end
    local person = person.next_in_room
end