-- Trigger: mesmeriz_death_banish
-- Zone: 302, ID: 20
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30220

-- Converted from DG Script #30220: mesmeriz_death_banish
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    person = nil
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("banish") == 3 then
                person.name:advance_quest("banish")
                person:send("<b:magenta>A single letter pops into your mind - <b:cyan>B</>")
            end
        end
        local i = i - 1
    end
elseif person:get_quest_stage("banish") == 3 then
    person.name:advance_quest("banish")
    person:send("<b:magenta>A single letter pops into your mind - <b:cyan>B</>")
end