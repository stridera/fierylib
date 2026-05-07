-- Trigger: Frost elf quest death
-- Zone: 534, ID: 106
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #53506

-- Converted from DG Script #53506: Frost elf quest death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Mark all group members in the room who shook the snow globe as having
-- killed a frost elf, so the quest can advance.
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_var("frost_valley_quest:shake") == 1 then
            person:set_quest_var("frost_valley_quest", "elf", 1)
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end