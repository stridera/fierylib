-- Trigger: ice_lord_death_banish
-- Zone: 302, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30215

-- For each grouped player still in the room at the killer's death, advance
-- the banish quest if they're at stage 2 (ice lord) and reveal the next letter.
local size = actor.group_size or 0
if size > 0 then
    for i = 1, size do
        local person = actor.group_member[i]
        if person and person.room == self.room
                and person:get_quest_stage("banish") == 2 then
            person:advance_quest("banish")
            person:send("<b:magenta>A single letter pops into your mind - <b:cyan>I</>")
        end
    end
elseif actor:get_quest_stage("banish") == 2 then
    actor:advance_quest("banish")
    actor:send("<b:magenta>A single letter pops into your mind - <b:cyan>I</>")
end