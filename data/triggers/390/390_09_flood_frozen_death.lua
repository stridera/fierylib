-- Trigger: flood_frozen_death
-- Zone: 390, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #39009

-- Converted from DG Script #39009: flood_frozen_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("<b:cyan>" .. tostring(self.name) .. " shatters into a thousand pieces!</>")
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("flood") == 1 then
                person.name:set_quest_var("flood", "water6", 1)
                local envoy = "yes"
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("flood") == 1 then
    person.name:set_quest_var("flood", "water6", 1)
    local envoy = "yes"
end
if envoy == "yes" then
    self.room:send("A chilly voice says, <b:cyan>'You have bested me, Envoy.  I acquiesce to your request.'</>")
end
local room = self.room
local person = room.people
while person do
    if person:get_quest_stage("flood") == 1 then
        local water1 = person:get_quest_var("flood:water1")
        local water2 = person:get_quest_var("flood:water2")
        local water3 = person:get_quest_var("flood:water3")
        local water4 = person:get_quest_var("flood:water4")
        local water5 = person:get_quest_var("flood:water5")
        local water6 = person:get_quest_var("flood:water6")
        local water7 = person:get_quest_var("flood:water7")
        local water8 = person:get_quest_var("flood:water8")
        if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
            person.name:advance_quest("flood")
            person.name:send("<b:blue>You have garnered the support of all the great waters!</>")
        end
    end
    local person = person.next_in_room
end
self:teleport(get_room(11, 0))
return _return_value