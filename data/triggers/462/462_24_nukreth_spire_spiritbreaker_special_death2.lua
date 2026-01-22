-- Trigger: Nukreth Spire spiritbreaker special death2
-- Zone: 462, ID: 24
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46224

-- Converted from DG Script #46224: Nukreth Spire spiritbreaker special death2
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_var("nukreth_spire:treasure") == 2 then
                person:set_quest_var("nukreth_spire", "treasure", 3)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
else
    if actor:get_quest_var("nukreth_spire:treasure") == 2 then
        actor:set_quest_var("nukreth_spire", "treasure", 3)
    end
end