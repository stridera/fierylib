-- Trigger: Rhell Merchant receive 3-3
-- Zone: 625, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62530

-- Converted from DG Script #62530: Rhell Merchant receive 3-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: after the druidstaff, the merchant asks for milk
if actor:get_quest_stage("ursa_quest") == 3 then
    if actor:get_quest_var("ursa_quest:choice") == 3 then
        if object.id == 16305 then
            wait(2)
            actor.name:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Oh, Golden Druidstaff!  Well, now that makes a lot of sense.")
            wait(1)
            self:say("Now we are to crush up this ring, and put the powder in milk.  Please, bring me some milk.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I don't think this is the Golhen DrubStatt the hermit had in mind.")
        end
    end
end
return _return_value