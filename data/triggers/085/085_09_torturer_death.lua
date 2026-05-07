-- Trigger: torturer_death
-- Zone: 85, ID: 9
-- Type: MOB, Flags: DEATH
--
-- When the torturer dies, advance the resurrection_quest stage for any
-- party members in the room who are at stage 2, or refresh the talisman
-- replacement marker for those holding the "new" var. Then fire the
-- bishop_room_trig (85_53) to release the bishop.
--
-- Original DG Script: #8509

-- Converted from DG Script #8509: torturer_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local run = false

local function check(person)
    if not person or person.room ~= self.room then return end
    if person:get_quest_stage("resurrection_quest") == 2 then
        person:advance_quest("resurrection_quest")
        run = true
    elseif person:get_quest_var("resurrection_quest:new") == "yes" then
        person:set_quest_var("resurrection_quest", "new", "new")
        run = true
    end
end

if actor.group then
    for _, member in ipairs(actor.group) do
        check(member)
    end
else
    check(actor)
end

if run then
    run_room_trigger(85, 53)
end