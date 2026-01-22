-- Trigger: Rhell Merchant receive 5-2
-- Zone: 625, ID: 35
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62535

-- Converted from DG Script #62535: Rhell Merchant receive 5-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 5 then
    if actor:get_quest_var("ursa_quest:choice") == 2 then
        -- extra step for evil path: merchant drinks and asks for a big bag - either a saddle or the tattered bag will work
        if object.type == "LIQCONTAINER" then
            wait(1)
            self:command("drink " .. tostring(object))
            wait(1)
            if object.val2 == 7 then
                self:say("This is the good stuff!")
                actor.name:advance_quest("ursa_quest")
                wait(1)
                self:command("drink " .. tostring(object))
                wait(1)
                self:say("Okay...  Now I'm ready.  All I need now is something to kill myself in.")
                wait(1)
                self:emote("looks around for a makeshift sarcophagus.")
                wait(2)
                self:say("Do you have something big enough for me to fit in?  Like a big box or a bag or something?")
            else
                self:command("spit " .. tostring(actor.name))
                wait(1)
                self:say("This isn't going to cut it, kid.")
                wait(2)
                self:say("Got anything stronger?")
                self:command("give " .. tostring(object) .. " " .. tostring(actor.name))
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm looking for a drink.  A strong one!")
        end
    end
end
return _return_value