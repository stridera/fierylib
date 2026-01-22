-- Trigger: Gothra_Old_Man_rece
-- Zone: 161, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16101

-- Converted from DG Script #16101: Gothra_Old_Man_rece
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- This is the script that give the prize for the effort
if object.id == 2023 then
    wait(1)
    self:destroy_item("bracelet")
    self:shout("Woo Hoo!")
    self:say("YES!")
    self:command("thanks " .. tostring(actor.name))
    self:say("I may actually get out of the dog house now!")
    self:command("grin me")
    wait(3)
    self:command("eye " .. tostring(actor.name))
    self:say("Hey, if you are resourceful enough to find this, then maybe you are up for some adventure!")
    self:command("grin")
    self.room:spawn_object(161, 4)
    self:command("give lever " .. tostring(actor.name))
    self:say("Good luck...")
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
            if not person:get_quest_stage("desert_quest") then
                person.name:start_quest("desert_quest")
            end
            person.name:set_quest_var("desert_quest", "lever", 1)
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
end