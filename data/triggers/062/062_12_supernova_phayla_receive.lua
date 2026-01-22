-- Trigger: supernova_phayla_receive
-- Zone: 62, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6212

-- Converted from DG Script #6212: supernova_phayla_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 51073 or object.id == 48917 then
    if actor.quest_variable[supernova:object.vnum] == 1 then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You've already given me this.")
    else
        actor.name:set_quest_var("supernova", "%object.vnum%", 1)
        wait(2)
        self:command("nod")
        world.destroy(object)
        if actor:get_quest_var("supernova:51073") and actor:get_quest_var("supernova:48917") then
            self:say("Alright, get comfortable.  This may take a while.")
            wait(3)
            self.room:send(tostring(self.name) .. " demonstrates some of the basics.")
            actor:send("You take notes and try to follow along.")
            wait(5)
            self:say("No, the diagrams need to look like this...")
            self.room:send_except(actor, tostring(self.name) .. " makes changes to " .. tostring(actor.name) .. "'s notes.")
            actor:send(tostring(self.name) .. " makes changes to your notes.")
            wait(5)
            self:say("Yes, that's good.  Move your hands like this.")
            self.room:send(tostring(self.name) .. " waves her hands about.")
            wait(5)
            self:say("Yes, that's much closer.")
            actor:send("You feel you're starting to get the hang of it!")
            self.room:send_except(actor, "It seems " .. tostring(actor.name) .. " is starting to get the hang of it!")
            wait(9)
            actor:send("You have a breakthrough!")
            self.room:send_except(actor, tostring(actor.name) .. " has a breakthrough!")
            wait(1)
            self:say("That's it!!  You've got it!")
            self.room:send_except(actor, tostring(actor.name) .. " radiates with inner arcane fire!")
            actor:send("<b:red>You have mastered Supernova!</>")
            skills.set_level(actor.name, "supernova", 100)
            actor.name:complete_quest("supernova")
        else
            self:say("And the other?")
        end
    end
else
    _return_value = false
    self:say("This isn't acceptable payment.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value