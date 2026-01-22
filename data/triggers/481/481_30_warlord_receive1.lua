-- Trigger: warlord_receive1
-- Zone: 481, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48130

-- Converted from DG Script #48130: warlord_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 48104 then
    wait(2)
    self:destroy_item("severed-head")
    self:command("smi")
    self:say("Ah, the enemy of my enemy is my friend.")
    wait(1)
    self:command("sigh")
    self.room:send(tostring(self.name) .. " says, 'I cannot help but feel that my son is still alive, " .. tostring(actor.name) .. ", but since none of my people have seen him he must be in the volcano.  I have too many responsibilities to leave and search for him.'")
    self:command("sniff")
    wait(1)
    self.room:spawn_object(481, 1)
    self.room:send(tostring(self.name) .. " says, 'If you find him, please give him this, and do all you can to help him.'")
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
            if not person:get_quest_stage("fieryisle_quest") then
                person.name:start_quest("fieryisle_quest")
                person:send("<b:white>You have now begun the Fiery Island quest!</>")
            end
            person.name:set_quest_var("fieryisle_quest", "shell", 1)
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
    self:command("give shell " .. tostring(actor.name))
    wait(2)
    self:say("The island shaman will know more.")
end