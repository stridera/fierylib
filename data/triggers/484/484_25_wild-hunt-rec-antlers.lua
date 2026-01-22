-- Trigger: wild-hunt-rec-antlers
-- Zone: 484, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48425

-- Converted from DG Script #48425: wild-hunt-rec-antlers
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
self:destroy_item("antlers")
local accept = 0
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("doom_entrance") == 2 then
            person.name:advance_quest("doom_entrance")
            self:command("bow " .. tostring(person.name))
            person:send(tostring(self.name) .. " says, 'You are indeed worthy, " .. tostring(person.name) .. ".  Please continue on to the Oracle of Justice.'")
            person:send("<b:white>You have advanced the quest!</>")
            local accept = 1
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if not accept then
    actor:send(tostring(self.name) .. " says, 'What is this?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You mock the Goddess of the Hunt!'")
end