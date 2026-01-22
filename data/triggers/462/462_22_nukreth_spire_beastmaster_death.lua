-- Trigger: Nukreth Spire beastmaster death
-- Zone: 462, ID: 22
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46222

-- Converted from DG Script #46222: Nukreth Spire beastmaster death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_var("nukreth_spire:baby") == 2 then
                person:set_quest_var("nukreth_spire", "baby", 3)
            elseif person:get_quest_var("nukreth_spire:baby") == 3 then
                person:set_quest_var("nukreth_spire", "baby", 4)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
else
    if actor:get_quest_var("nukreth_spire:baby") == 2 then
        actor:set_quest_var("nukreth_spire", "baby", 3)
    elseif actor:get_quest_var("nukreth_spire:baby") == 3 then
        actor:set_quest_var("nukreth_spire", "baby", 4)
    end
end