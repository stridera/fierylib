-- Trigger: word_command_voliangloch_death
-- Zone: 430, ID: 55
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #43055

-- Converted from DG Script #43055: word_command_voliangloch_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " says, 'Cyprianum will never allow you to escape this place!'")
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("word_command") == 1 then
            person.name:advance_quest("word_command")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end