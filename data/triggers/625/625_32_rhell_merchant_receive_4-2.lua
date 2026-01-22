-- Trigger: Rhell Merchant receive 4-2
-- Zone: 625, ID: 32
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62532

-- Converted from DG Script #62532: Rhell Merchant receive 4-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 2, the merchant asks for hard liquor - firebreather is best.
if actor:get_quest_stage("ursa_quest") == 4 then
    if actor:get_quest_var("ursa_quest:choice") == 2 then
        if object.id == 59012 then
            wait(2)
            world.destroy(object)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            self:say("Fantastic.  Rylee knew it had too much power to be wielded by just anyone.  Only this dagger can end the curse inside me.")
            wait(1)
            self:say("Now, it says here that the king was placed in his sarcophagus and slew the beast inside himself.")
            wait(2)
            self:say("I'm willing to do that... but not sober.  Fetch me something to drink, and make it strong!")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("What is this garbage?  I need the king's jeweled dagger.  Only it has the radiant power to kill the beast.")
        end
    end
end
return _return_value