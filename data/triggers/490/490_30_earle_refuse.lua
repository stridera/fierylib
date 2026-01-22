-- Trigger: Earle refuse
-- Zone: 490, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49030

-- Converted from DG Script #49030: Earle refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("major_globe_spell") == 2 then
    if object.id == 53451 then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 3 then
    elseif object.id == 58002 then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 4 then
    elseif object.id == 58609 then
        return _return_value
    end
end
_return_value = false
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
wait(4)
self:command("shake")
self:say("Sorry, I don't think this will be of any use.")
wait(8)
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return _return_value