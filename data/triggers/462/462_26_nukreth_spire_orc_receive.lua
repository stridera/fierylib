-- Trigger: Nukreth Spire orc receive
-- Zone: 462, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46226

-- Converted from DG Script #46226: Nukreth Spire orc receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path3") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 13 then
                wait(0.2)
                self.room:send(tostring(self.name) .. " grins wickedly as he wraps his fingers around the axe.")
                self:command("wie axe")
                wait(1)
                self:say("Revenge will be sweet...")
                wait(2)
                self:say("Now move out!")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my axe.")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my axe.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value