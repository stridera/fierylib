-- Trigger: assassin_subclass_mayor_death
-- Zone: 60, ID: 32
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #6032

-- Converted from DG Script #6032: assassin_subclass_mayor_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" and person:get_quest_stage("merc_ass_thi_subclass") == 3 then
                person.name:set_quest_var("merc_ass_thi_subclass", "mayor", 1)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" and actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor.name:set_quest_var("merc_ass_thi_subclass", "mayor", 1)
end