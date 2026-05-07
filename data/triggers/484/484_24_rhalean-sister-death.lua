-- Trigger: rhalean-sister-death
-- Zone: 484, ID: 24
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48424

-- Converted from DG Script #48424: rhalean-sister-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
local found
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("doom_entrance") == 3 then
            person:advance_quest("doom_entrance")
            person:send("<b:white>You have advanced the quest!</>")
            found = 1
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end
if found then
    self.room:send("<blue>Rhalean's presence fills the room as her evil sister shrieks in pain!</>")
end