-- Trigger: Norisent_death_degeneration
-- Zone: 55, ID: 23
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5523

-- Converted from DG Script #5523: Norisent_death_degeneration
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("degeneration") == 7 then
                person:advance_quest("degeneration")
                self.room:spawn_object(85, 51)
                self.room:send("<b:green>A small book slips from " .. tostring(self.name) .. "'s robes.</>")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_stage("degeneration") == 7 then
    actor:advance_quest("degeneration")
    self.room:spawn_object(85, 51)
    self.room:send("<b:green>A small book slips from " .. tostring(self.name) .. "'s robes.</>")
end