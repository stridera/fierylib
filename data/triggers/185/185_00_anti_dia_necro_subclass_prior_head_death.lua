-- Trigger: anti_dia_necro_subclass_prior_head_death
-- Zone: 185, ID: 0
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #18500

-- Converted from DG Script #18500: anti_dia_necro_subclass_prior_head_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Subclass drop trigger
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("nec_dia_ant_subclass") == 3 then
                local drophead = 1
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("nec_dia_ant_subclass") == 3 then
    local drophead = 1
end
if drophead == 1 then
    self.room:spawn_object(85, 4)
end