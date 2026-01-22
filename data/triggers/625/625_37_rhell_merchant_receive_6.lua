-- Trigger: Rhell Merchant receive 6
-- Zone: 625, ID: 37
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62537

-- Converted from DG Script #62537: Rhell Merchant receive 6
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 6 then
    if actor:get_quest_var("ursa_quest:choice") == 2 then
        if object.type == "CONTAINER" then
            wait(2)
            self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
            if object.val0 > 120 then
                -- The following regular items can be picked up and have large enough values: 3147, 16102, 55029
                wait(2)
                world.destroy(object)
                run_room_trigger(62550)
            else
                wait(1)
                self:command("shake")
                self:say("I don't think I can fit in here.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor))
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I need a body-bag or a large chest...")
        end
    end
end
return _return_value