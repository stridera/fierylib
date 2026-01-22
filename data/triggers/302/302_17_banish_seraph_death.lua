-- Trigger: banish_seraph_death
-- Zone: 302, ID: 17
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30217

-- Converted from DG Script #30217: banish_seraph_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    person = nil
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("banish") == 6 then
                person.name:advance_quest("banish")
                person:send("<b:magenta>A single letter pops into your mind - <b:cyan>P</>")
            end
        end
        local i = i - 1
    end
elseif person:get_quest_stage("banish") == 6 then
    person.name:advance_quest("banish")
    person:send("<b:magenta>A single letter pops into your mind - <b:cyan>P</>")
end