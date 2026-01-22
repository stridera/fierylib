-- Trigger: hell_gate_larathiel_death
-- Zone: 564, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #56407

-- Converted from DG Script #56407: hell_gate_larathiel_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("With an anguished cry, Larathiel dies screaming in agony!")
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("hell_gate") == 5 then
                person.name:advance_quest("hell_gate")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("hell_gate") == 5 then
    person.name:advance_quest("hell_gate")
end
run_room_trigger(56408)
return _return_value