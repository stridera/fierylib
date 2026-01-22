-- Trigger: Nukreth Spire orc receive
-- Zone: 462, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46226

-- Converted from DG Script #46226: Nukreth Spire orc receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path3") == 0 then
        if task ~= "done" then
            if object.id == 46213 then
                wait(2)
                self.room:send(tostring(self.name) .. " grins wickedly as he wraps his fingers around the axe.")
                self:command("wie axe")
                wait(1)
                self:say("Revenge will be sweet...")
                wait(2)
                self:say("Now move out!")
                self:follow(actor)
                local task = "done"
                globals.task = globals.task or true
                local leader = actor.name
                globals.leader = globals.leader or true
            else
                _return_value = false
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my axe.")
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my axe.")
        end
    else
        _return_value = false
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    _return_value = false
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end
return _return_value