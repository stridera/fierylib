-- Trigger: Armor Exchange greeting
-- Zone: 30, ID: 50
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #3050

-- Converted from DG Script #3050: Armor Exchange greeting
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.id == -1 then
    local item = actor:get_quest_var("armor_exchange:gem_vnum")
    if actor:get_quest_stage("armor_exchange") == 1 then
        actor:send(tostring(self.name) .. " shouts to you, 'Well howdy-hoo!  Welcome back!'")
        self:command("grin " .. tostring(actor))
        wait(2)
        if item == 0 then
            actor:send(tostring(self.name) .. " says, 'Tell me dearie, what can I help ya find today?'")
        else
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. "%get.obj_shortdesc[%item%]%?'")
        end
    else
        actor:send(tostring(self.name) .. " hollers, 'Well hello there dearie!  Welcome to a land of rare and valuable treasures!'")
        actor:send(tostring(self.name) .. " indicates the massive piles of junk.")
        wait(1)
        actor:send(tostring(self.name) .. " says to you, 'We can trade all manner of precious old goodies here.  People leave behind armor they don't want anymore for stuff they do.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'So what can I help you find today?'")
    end
end