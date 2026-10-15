-- Trigger: Nukreth Spire goblin receive
-- Zone: 462, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46227

-- Converted from DG Script #46227: Nukreth Spire goblin receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 15 then
                wait(0.2)
                world.destroy(object)
                self:command("cheer")
                self:say("Come to papa!")
                self.room:send(tostring(self.name) .. " grins like a fool at the stone.")
                wait(2)
                self:say("Thanks matey.  Now get me outta 'ere.")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only want me stone.")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have me stone.")
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