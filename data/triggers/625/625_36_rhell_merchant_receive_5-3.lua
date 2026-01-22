-- Trigger: Rhell Merchant receive 5-3
-- Zone: 625, ID: 36
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62536

-- Converted from DG Script #62536: Rhell Merchant receive 5-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on neutral quest: merchant turns into Ursa and fights!
-- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
if actor:get_quest_stage("ursa_quest") == 5 then
    if actor:get_quest_var("ursa_quest:choice") == 3 then
        if object.id == 8702 then
            wait(2)
            world.destroy(object)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(62550)
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This won't do the job.  I need the anvil.")
        end
    end
end
return _return_value