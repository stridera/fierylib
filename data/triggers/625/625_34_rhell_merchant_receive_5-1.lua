-- Trigger: Rhell Merchant receive 5-1
-- Zone: 625, ID: 34
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62534

-- Converted from DG Script #62534: Rhell Merchant receive 5-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on good quest: either the pitcher from dancing dolphin or hot springs will work; merchant is healed and the thorny staff transforms into the redeeming staff.
if actor:get_quest_stage("ursa_quest") == 5 then
    if actor:get_quest_var("ursa_quest:choice") == 1 then
        if object.id == 10309 or object.id == 58706 then
            wait(1)
            world.destroy(object)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(62550)
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This just won't work.  Really, what I need is a pitcher, so I can quickly and accurately pour a large amount of water.")
        end
    end
end
return _return_value