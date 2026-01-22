-- Trigger: demon_lord_death
-- Zone: 160, ID: 25
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16025

-- Converted from DG Script #16025: demon_lord_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- advance the quest
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person.name:set_quest_var("mystwatch_quest", "step", "complete")
            person:send("<b:white>You have slain the Demon Lord of Mystwatch!</>")
            person:send("<b:white>Group credit will not be given for returning the emerald shard to the Templar Magistrate.</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end