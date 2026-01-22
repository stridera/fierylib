-- Trigger: drider-king-death
-- Zone: 237, ID: 56
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23756

-- Converted from DG Script #23756: drider-king-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
-- This is for the vilekka_stew quest, stage 2.
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("vilekka_stew") == 3 then
                local quest = "yes"
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("vilekka_stew") == 3 then
    local quest = "yes"
end
if quest == "yes" then
    _return_value = false
    self.room:send("With a horrible shriek, the drider king's body melts!")
    self.room:spawn_object(237, 20)
end
return _return_value