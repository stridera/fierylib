-- Trigger: Unicorn Girl receive
-- Zone: 584, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #58404

-- Converted from DG Script #58404: Unicorn Girl receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 58435 then
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
            if not person:get_quest_stage("kod_quest") then
                person.name:start_quest("kod_quest")
            end
            person:set_quest_var("kod_quest", "alicorn", 1)
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    world.destroy(self.room:find_actor("girl"))
end