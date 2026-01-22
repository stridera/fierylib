-- Trigger: Nukreth Spire goblin receive
-- Zone: 462, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46227

-- Converted from DG Script #46227: Nukreth Spire goblin receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path4") == 0 then
        if task ~= "done" then
            if object.id == 46215 then
                wait(2)
                world.destroy(object)
                self:command("cheer")
                self:say("Come to papa!")
                self.room:send(tostring(self.name) .. " grins like a fool at the stone.")
                wait(2)
                self:say("Thanks matey.  Now get me outta 'ere.")
                self:follow(actor)
                local task = "done"
                globals.task = globals.task or true
                local leader = actor.name
                globals.leader = globals.leader or true
            else
                _return_value = false
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only want me stone.")
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have me stone.")
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