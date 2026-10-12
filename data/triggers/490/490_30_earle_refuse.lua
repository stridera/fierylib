-- Trigger: Earle refuse
-- Zone: 490, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49030

-- Converted from DG Script #49030: Earle refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (49001 49029 49037 49045) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 490 and object.id == 1)
    or (object.zone_id == 490 and object.id == 29)
    or (object.zone_id == 490 and object.id == 37)
    or (object.zone_id == 490 and object.id == 45) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("major_globe_spell") == 2 then
    if (object.zone_id == 534 and object.id == 51) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 3 then
    elseif (object.zone_id == 580 and object.id == 2) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 4 then
    elseif (object.zone_id == 586 and object.id == 9) then
        return _return_value
    end
end
_return_value = true
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
wait(4)
self:command("shake")
self:say("Sorry, I don't think this will be of any use.")
wait(8)
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return _return_value