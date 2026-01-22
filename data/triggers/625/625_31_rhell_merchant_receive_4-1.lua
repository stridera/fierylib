-- Trigger: Rhell Merchant receive 4-1
-- Zone: 625, ID: 31
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62531

-- Converted from DG Script #62531: Rhell Merchant receive 4-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, the merchant thinks he's done, but realizes he needs a pitcher to pour water over the other items.
if actor:get_quest_stage("ursa_quest") == 4 then
    if actor:get_quest_var("ursa_quest:choice") == 1 then
        if object.id == 8516 then
            wait(2)
            actor.name:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Excellent!  Now I have everything I need: the pepper, the plant, the staff, this spring's water...")
            wait(2)
            self:emote("stares blankly at the spring.")
            wait(3)
            self:say("So...")
            wait(1)
            self:say("I need to get the water in something functional.  Can you go get a pitcher?  That would do the job wonderfully.")
            self:command("smile " .. tostring(actor))
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the thorny wood I need.")
        end
    end
end
return _return_value