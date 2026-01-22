-- Trigger: Rhell Merchant receive 3-2
-- Zone: 625, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62529

-- Converted from DG Script #62529: Rhell Merchant receive 3-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: after bringing the sunstone diadem, merchant asks for the radiant dagger, an mload in sacred haven
if actor:get_quest_stage("ursa_quest") == 3 then
    if actor:get_quest_var("ursa_quest:choice") == 2 then
        if object.id == 55014 then
            wait(2)
            actor.name:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:emote("inspects the stone.")
            wait(2)
            self:say("You are quite resourceful.  This was the ancient king's pendant.")
            wait(2)
            self:say("It is said the sunstone captured the sun's light over 2 ages.  Now it shines with that stolen light.")
            wait(3)
            self:say("There is a dagger that the king used that does quite the opposite.")
            wait(3)
            self:say("It absorbs no light, it seems, but is made of such fine gold and gems that it radiates light.  The priests of South Caelia recognize its fierce beauty.  You will find it there still.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the sunstone.  Find and return it.")
        end
    end
end
return _return_value