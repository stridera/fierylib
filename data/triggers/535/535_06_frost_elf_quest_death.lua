-- Trigger: Frost elf quest death
-- Zone: 535, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #53506

-- Converted from DG Script #53506: Frost elf quest death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_var("frost_valley_quest:shake") == 1 then
            person.name:set_quest_var("frost_valley_quest", "elf", 1)
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end