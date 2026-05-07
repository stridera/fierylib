-- Trigger: mesmeriz_death_banish
-- Zone: 302, ID: 20
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #30220

-- For each grouped player still in the room at the killer's death, advance
-- the banish quest if they're at stage 3 (mesmeriz) and reveal the next letter.
local size = actor.group_size or 0
if size > 0 then
    for i = 1, size do
        local person = actor.group_member[i]
        if person and person.room == self.room
                and person:get_quest_stage("banish") == 3 then
            person:advance_quest("banish")
            person:send("<b:magenta>A single letter pops into your mind - <b:cyan>B</>")
        end
    end
elseif actor:get_quest_stage("banish") == 3 then
    actor:advance_quest("banish")
    actor:send("<b:magenta>A single letter pops into your mind - <b:cyan>B</>")
end