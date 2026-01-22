-- Trigger: Rhell Merchant receive 2-2
-- Zone: 625, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62526

-- Converted from DG Script #62526: Rhell Merchant receive 2-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: if the golden sceptre is returned, the merchant asks for the sunstone diadem from tech.
if actor:get_quest_stage("ursa_quest") == 2 then
    if actor:get_quest_var("ursa_quest:choice") == 2 then
        if object.id == 16201 then
            wait(2)
            world.destroy(object)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            self:emote("runs his hand down the shaft of the golden sceptre.")
            wait(2)
            self:say("What power!")
            wait(2)
            self:say("The king also wore an emblem of the sun.")
            wait(1)
            self:say("Ruin believes this emblem to be the very one written of in the legends of the warring gods in the far north.")
            wait(2)
            self:say("I feel the sceptre longing for it.  Find the sunstone and bring it to me.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the king's golden sceptre.")
        end
    end
end
return _return_value