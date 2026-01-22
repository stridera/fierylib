-- Trigger: quest_suralla_burningshrub_dead
-- Zone: 550, ID: 25
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55025

-- Converted from DG Script #55025: quest_suralla_burningshrub_dead
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " says, 'Thank you for ending my pain.'")
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("cryomancer_subclass") == 3 then
                person.name:advance_quest("cryomancer_subclass")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("cryomancer_subclass") == 3 then
    person.name:advance_quest("cryomancer_subclass")
end