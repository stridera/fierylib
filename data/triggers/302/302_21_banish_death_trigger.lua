-- Trigger: Banish death trigger
-- Zone: 302, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30221

-- Converted from DG Script #30221: Banish death trigger
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
local stage = nil
local letter = nil
if self.id == 41119 then
    -- Sea Witch
    stage = 1
    letter = "V"
elseif self.id == 53313 then
    -- Ice Lord
    stage = 2
    letter = "I"
elseif self.id == 37000 then
    -- Mesmeriz
    stage = 3
    letter = "B"
elseif self.id == 48005 then
    -- Eidolon
    stage = 4
    letter = "U"
elseif self.id == 53417 then
    -- Chaos Demon
    stage = 5
    letter = "G"
elseif self.id == 23811 then
    -- lesser seraph
    stage = 6
    letter = "P"
end
if not stage then
    return
end
local person = actor
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
person = nil
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("banish") == stage then
            person.name:advance_quest("banish")
            person:set_quest_var("banish", "greet", 0)
            person:send("<b:magenta>A single letter pops into your mind - <b:cyan>" .. tostring(letter) .. "</>")
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end