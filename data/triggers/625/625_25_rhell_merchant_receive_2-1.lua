-- Trigger: Rhell Merchant receive 2-1
-- Zone: 625, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62525

-- Converted from DG Script #62525: Rhell Merchant receive 2-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after pepper, the merchant needs a plant, found in the form of 'a bit of bones and plants' from blue fog trail.
if actor:get_quest_stage("ursa_quest") == 2 then
    if actor:get_quest_var("ursa_quest:choice") == 1 then
        if object.id == 23755 then
            wait(2)
            actor.name:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Good!  You managed to find some pepper.")
            wait(1)
            self:say("I've been looking over this next item, and it should be a lot less hassle.")
            wait(2)
            self:say("Just west of here, there is a plant that roots to sticks and rocks, and even beings if they hold still long enough.  I need some of that plant.  It shouldn't be too hard.")
            wait(1)
            self:say("... I think.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't what I need right now.  Please bring me some pepper.")
        end
    end
end
return _return_value