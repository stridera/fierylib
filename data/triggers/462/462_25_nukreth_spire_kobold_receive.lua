-- Trigger: Nukreth Spire kobold receive
-- Zone: 462, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46225

-- Converted from DG Script #46225: Nukreth Spire kobold receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path2") == 0 then
        if task ~= "done" then
            if object.id == 46214 then
                wait(2)
                world.destroy(object)
                self.room:send(tostring(self.name) .. " trills excitedly!")
                wait(1)
                self:say("It's okay, momma's got you now.")
                self.room:send(tostring(self.name) .. " coos at the egg as she cradles it in her arms.")
                wait(2)
                self:say("Thank you!!  Now let's get out of here.")
                self:follow(actor)
                local task = "done"
                globals.task = globals.task or true
                local leader = actor.name
                globals.leader = globals.leader or true
            else
                _return_value = false
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my egg.")
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my egg.")
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