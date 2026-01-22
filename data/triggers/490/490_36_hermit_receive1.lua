-- Trigger: hermit_receive1
-- Zone: 490, ID: 36
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49036

-- Converted from DG Script #49036: hermit_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.type == "LIQCONTAINER" then
    wait(2)
    if object.val2 == 5 then
        self:command("cheer")
        self:say("Thank you " .. tostring(actor.name) .. ", you have made an old man very happy.")
        self.room:spawn_object(490, 41)
        local person = actor
        local i = person.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = person.group_member[a]
            if person.room == self.room then
                if not person:get_quest_stage("griffin_quest") then
                    person:start_quest("griffin_quest")
                end
                person:set_quest_var("griffin_quest", "ladder", 1)
            elseif person and person.id == -1 then
                local i = i + 1
            end
            local a = a + 1
        end
        self:command("give ladder " .. tostring(actor.name))
        self:say("That completes my part of the bargain.")
        wait(2)
        self:command("drink bottle")
        self:command("smile")
    else
        self:say("I'm not drinking this!")
        self:command("pour " .. tostring(object) .. " out")
        self:command("drop " .. tostring(object))
    end
else
    _return_value = false
    self:say("What's this for?")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value