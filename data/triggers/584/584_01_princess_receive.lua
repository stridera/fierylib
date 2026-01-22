-- Trigger: princess_receive
-- Zone: 584, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #58401

-- Converted from DG Script #58401: princess_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 58417 then
    wait(1)
    self.room:send(tostring(self.name) .. " sighs in great relief.")
    wait(2)
    self:say("Thank you from the bottom of my heart, kind adventurer.")
    self:say("Your deeds shall not go unrewarded.")
    wait(2)
    self:destroy_item("feathers")
    self.room:spawn_object(584, 1)
    self:command("give feather " .. tostring(actor.name))
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
            person:set_quest_var("kod_quest", "feather", 1)
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
end