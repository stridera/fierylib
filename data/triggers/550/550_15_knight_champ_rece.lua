-- Trigger: Knight_Champ_rece
-- Zone: 550, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55015

-- Converted from DG Script #55015: Knight_Champ_rece
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Knight Champion Receive object for quest goodie
if object.zone_id == 550 and object.local_id == 4 then
    wait(1)
    local i = actor.group_size or 0
    local a = 1
    while a <= i do
        local person = actor.group_member[a]
        if person and person.room == self.room then
            if not person:get_quest_stage("tech_mysteries_quest") then
                person:start_quest("tech_mysteries_quest")
            end
            person:set_quest_var("tech_mysteries_quest", "girth", 1)
        end
        a = a + 1
    end
    self.room:send(tostring(self.name) .. " says, 'You did it!  You have the book!  The only way would have been to venture to the planes and destroy Xapizo!'")
    self:destroy_item("codex")
    self:say("I know the Snow Leopard would want you to have this.")
    self.room:spawn_object(550, 13)
    self:command("give girth " .. tostring(actor.name))
    self:command("drop girth")
else
    wait(1)
    self:command("eye " .. tostring(actor.name))
end