-- Trigger: Niaxxa death
-- Zone: 615, ID: 71
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #61571

-- Converted from DG Script #61571: Niaxxa death
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
        if person:get_quest_stage("enchanted_hollow_quest") and not person:get_has_completed("enchanted_hollow_quest") then
            person.name:complete_quest("enchanted_hollow_quest")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end