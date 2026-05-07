-- Trigger: Unicorn Girl receive
-- Zone: 584, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #58404
--
-- Receiving the legal writ (object 584/35) frees the unicorn girl: she removes
-- her fetter, hands the actor an alicorn necklace (584/29), credits every
-- grouped player in the room with the "alicorn" step of kod_quest, and then
-- despawns herself.

-- Only react when the legal writ is received.
if not (object.zone_id == 584 and object.local_id == 35) then
    return true
end

wait(1)
self:destroy_item("legal")
self.room:send(tostring(self.name) .. " begins to sob hysterically.")
self:say("Thank you, thank you so very much!")
wait(2)
self:command("rem fetter")
self:command("drop fetter")
self:say("I am free!")
wait(2)
self:say("Please accept this gift, as reward for setting me free.")
wait(2)
self.room:send("The slave girl pulls a necklace with a spiral horn from her tattered clothes.")
wait(2)
self.room:spawn_object(584, 29)
self:command("give alicorn " .. tostring(actor.name))
wait(2)
self:say("I must return to my family!")
self.room:send("The slave girl quickly runs away!")

-- Credit every grouped player still in the room with the "alicorn" step;
-- fall back to crediting the lone actor if they are not in a group.
local size = actor.group_size or 0
if size > 0 then
    for i = 1, size do
        local person = actor.group_member[i]
        if person and person.room == self.room then
            if not person:get_quest_stage("kod_quest") then
                person:start_quest("kod_quest")
            end
            person:set_quest_var("kod_quest", "alicorn", 1)
        end
    end
else
    if not actor:get_quest_stage("kod_quest") then
        actor:start_quest("kod_quest")
    end
    actor:set_quest_var("kod_quest", "alicorn", 1)
end

world.destroy(self)