-- Trigger: supernova_sunchild_death
-- Zone: 62, ID: 5
-- Type: MOB, Flags: DEATH
--
-- When the Sunchild dies, advance the supernova quest from stage 1 -> 2 for
-- the killer (and any group member in the same room who is on the quest).
--
-- Original DG Script: #6205

if actor.group then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("supernova") == 1 then
            person:advance_quest("supernova")
        end
    end
elseif actor:get_quest_stage("supernova") == 1 then
    actor:advance_quest("supernova")
end