-- Trigger: quest_suralla_burningshrub_dead
-- Zone: 550, ID: 25
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55025

-- Converted from DG Script #55025: quest_suralla_burningshrub_dead
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " says, 'Thank you for ending my pain.'")
local i = actor.group_size or 0
if i > 0 then
    local a = 1
    while a <= i do
        local person = actor.group_member[a]
        if person and person.room == self.room then
            if person:get_quest_stage("cryomancer_subclass") == 3 then
                person:advance_quest("cryomancer_subclass")
            end
        end
        a = a + 1
    end
elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
    actor:advance_quest("cryomancer_subclass")
end