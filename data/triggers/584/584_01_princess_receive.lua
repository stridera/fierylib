-- Trigger: princess_receive
-- Zone: 584, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #58401
--
-- When the princess is given the swan feathers (object 584/17), she thanks the
-- adventurer, destroys the feathers, spawns a single feather reward (584/1),
-- and marks every group member in the room with the "feather" step of the
-- kod_quest.

-- Only react when the swan feathers are received.
if not (object.zone_id == 584 and object.local_id == 17) then
    return true
end

wait(1)
self.room:send(tostring(self.name) .. " sighs in great relief.")
wait(2)
self:say("Thank you from the bottom of my heart, kind adventurer.")
self:say("Your deeds shall not go unrewarded.")
wait(2)
self:destroy_item("feathers")
self.room:spawn_object(584, 1)
self:command("give feather " .. tostring(actor.name))

-- Credit every grouped player still in the room with the "feather" step;
-- fall back to crediting the lone actor if they are not in a group.
local size = actor.group_size or 0
if size > 0 then
    for i = 1, size do
        local person = actor.group_member[i]
        if person and person.room == self.room then
            if not person:get_quest_stage("kod_quest") then
                person:start_quest("kod_quest")
            end
            person:set_quest_var("kod_quest", "feather", 1)
        end
    end
else
    if not actor:get_quest_stage("kod_quest") then
        actor:start_quest("kod_quest")
    end
    actor:set_quest_var("kod_quest", "feather", 1)
end