-- Trigger: ivory-key-get
-- Zone: 481, ID: 7
-- Type: OBJECT, Flags: GET, GIVE
-- Status: CLEAN
--
-- Original DG Script: #48107

-- Converted from DG Script #48107: ivory-key-get
-- Original: OBJECT trigger, flags: GET, GIVE, probability: 100%
local stage = 6
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
        if person:get_quest_stage("fieryisle_quest") == "stage" then
            person.name:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
if victim:get_quest_stage("fieryisle_quest") == "stage" then
    victim.name:advance_quest("fieryisle_quest")
    victim:send("<b:white>You have advanced your quest!</>")
end