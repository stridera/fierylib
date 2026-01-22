-- Trigger: Scorpion desert quest death
-- Zone: 161, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16106

-- Converted from DG Script #16106: Scorpion desert quest death
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
        if person:get_quest_stage("desert_quest") then
            person.name:set_quest_var("desert_quest", "scorpion", 1)
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end