-- Trigger: Master Shaman skull receive
-- Zone: 550, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55007

-- Converted from DG Script #55007: Master Shaman skull receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
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
        if not person:get_quest_stage("tech_mysteries_quest") then
            person.name:start_quest("tech_mysteries_quest")
        end
        person.name:set_quest_var("tech_mysteries_quest", "cloak", 1)
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
self:destroy_item("skull")
self:say("Oh my!  You have destroyed a great evil!  My kingdom will never be threatened by it again!")
wait(2)
self:command("thank " .. tostring(actor.name))
wait(2)
self:say("I know the Snow Leopard would want you to have this!")
self.room:spawn_object(550, 8)
self:command("give cloak " .. tostring(actor.name))
self:command("drop cloak")