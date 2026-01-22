-- Trigger: derceta_receive1
-- Zone: 490, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49023

-- Converted from DG Script #49023: derceta_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 49016 then
    self:set_flag("sentinel", true)
    local person = actor
    local stage = 3
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = person.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("griffin_quest") == "stage" then
                person.name:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
            end
            if actor:get_quest_stage("griffin_quest") < stage then
                local leader = person
            else
                local leader = actor
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
    wait(2)
    self:command("smile")
    self:say("Thanks " .. tostring(leader.name) .. ".  Now, lead me to the boulder.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'When you want it shifted, say <b:white>'push now'</> and I will get to work.'")
    self:follow(leader.name)
    wait(4)
    self:say("Be ready to move quick - I won't be able to hold it forever.")
    self:emote("polishes the earring.")
    self:emote("peers at the earring and says 'Hello little midget.'")
    wait(8)
    self:command("wear earring ear")
else
    _return_value = false
    self:command("shake")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
end
return _return_value