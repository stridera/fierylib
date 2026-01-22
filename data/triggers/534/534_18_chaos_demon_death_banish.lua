-- Trigger: chaos_demon_death_banish
-- Zone: 534, ID: 18
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #53418

-- Converted from DG Script #53418: chaos_demon_death_banish
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    person = nil
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("banish") == 5 then
                person.name:advance_quest("banish")
                person:send("<b:magenta>A single letter pops into your mind. - <b:cyan>G</>")
            end
        end
        local i = i - 1
    end
elseif person:get_quest_stage("banish") == 5 then
    person.name:advance_quest("banish")
    person:send("<b:magenta>A single letter pops into your mind. - <b:cyan>G</>")
end