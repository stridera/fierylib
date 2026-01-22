-- Trigger: group_heal_rite_give
-- Zone: 185, ID: 24
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #18524

-- Converted from DG Script #18524: group_heal_rite_give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("group_heal") == 5 then
    if victim.id == 50203 or victim.id == 51007 or victim.id == 8307 or victim.id == 18512 or victim.id == 10308 or victim.id == 30003 then
        actor:send("You show " .. tostring(victim.name) .. " " .. tostring(self.shortdesc) .. ".")
        self.room:send_except(actor, tostring(actor.name) .. " shows " .. tostring(victim.name) .. " " .. tostring(self.shortdesc) .. ".")
        return _return_value
    else
        _return_value = false
        actor:send("You should not give away something so precious!")
    end
elseif actor:get_quest_stage("group_heal") == 6 then
    if victim.id == 18521 then
        return _return_value
    else
        _return_value = false
        actor:send("You should not give away something so precious!")
    end
end
return _return_value