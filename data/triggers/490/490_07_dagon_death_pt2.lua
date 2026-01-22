-- Trigger: dagon_death_pt2
-- Zone: 490, ID: 7
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #49007

-- Converted from DG Script #49007: dagon_death_pt2
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local person = self.people
while person do
    if person:get_quest_stage("griffin_quest") == 6 then
        person.name:advance_quest("griffin_quest")
        person:send("<b:white>You have advanced the quest!</>")
        person:send("<b:white>Proof of the deed must be delivered individually.</>")
    end
    local person = person.next_in_room
end