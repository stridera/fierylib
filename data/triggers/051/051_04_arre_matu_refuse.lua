-- Trigger: Arre Matu refuse
-- Zone: 51, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5104

-- Converted from DG Script #5104: Arre Matu refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
_return_value = false
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(1)
self:command("eye " .. tostring(actor.name))
actor:send(tostring(self.name) .. " says, 'What is this? I have no need for " .. tostring(object.shortdesc) .. ".'")
return _return_value