-- Trigger: Banish death trigger
-- Zone: 302, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30221

-- Converted from DG Script #30221: Banish death trigger
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 41119 then
    -- Sea Witch
    local stage = 1
    local letter = "V"
elseif self.id == 53313 then
    -- Ice Lord
    local stage = 2
    local letter = "I"
elseif self.id == 37000 then
    -- Mesmeriz
    local stage = 3
    local letter = "B"
elseif self.id == 48005 then
    -- Eidolon
    local stage = 4
    local letter = "U"
elseif self.id == 53417 then
    -- Chaos Demon
    local stage = 5
    local letter = "G"
elseif self.id == 23811 then
    -- lesser seraph
    local stage = 6
    local letter = "P"
end
local person = actor
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
person = nil
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("banish") == "stage" then
            person.name:advance_quest("banish")
            person:set_quest_var("banish", "greet", 0)
            person:send("<b:magenta>A single letter pops into your mind - <b:cyan>" .. tostring(letter) .. "</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end