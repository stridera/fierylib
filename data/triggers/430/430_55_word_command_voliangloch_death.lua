-- Trigger: word_command_voliangloch_death
-- Zone: 430, ID: 55
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #43055

-- Converted from DG Script #43055: word_command_voliangloch_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " says, 'Cyprianum will never allow you to escape this place!'")
-- Advance the Word of Command quest for every group member present at the kill.
for _, person in ipairs(actor.group) do
    if person.room == self.room and person:get_quest_stage("word_command") == 1 then
        person:advance_quest("word_command")
    end
end