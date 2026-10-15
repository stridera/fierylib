-- Trigger: Master Shaman skull receive
-- Zone: 550, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55007

-- Converted from DG Script #55007: Master Shaman skull receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55005): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 5)
) then
    return true
end

wait(0.2)
local i = actor.group_size or 0
local a = 1
while a <= i do
    local person = actor.group_member[a]
    if person and person.room == self.room then
        if person:get_quest_stage("tech_mysteries_quest") == 0 then
            person:start_quest("tech_mysteries_quest")
        end
        person:set_quest_var("tech_mysteries_quest", "cloak", 1)
    end
    a = a + 1
end
self:destroy_item("skull")
self:say("Oh my!  You have destroyed a great evil!  My kingdom will never be threatened by it again!")
wait(0.2)
self:command("thank " .. tostring(actor.name))
wait(0.2)
self:say("I know the Snow Leopard would want you to have this!")
self.room:spawn_object(550, 8)
self:command("give cloak " .. tostring(actor.name))
self:command("drop cloak")