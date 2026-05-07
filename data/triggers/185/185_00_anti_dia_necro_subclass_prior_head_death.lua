-- Trigger: anti_dia_necro_subclass_prior_head_death
-- Zone: 185, ID: 0
-- Type: MOB, Flags: DEATH
--
-- On the Prior's death: if any present group member of his killer is on
-- stage 3 of the anti-diabolist/necromancer subclass quest, drop his
-- severed head (object 85,4) for the quest.

local drophead = false
if actor.group and #actor.group > 0 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("nec_dia_ant_subclass") == 3 then
            drophead = true
            break
        end
    end
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 3 then
    drophead = true
end

if drophead then
    self.room:spawn_object(85, 4)
end
