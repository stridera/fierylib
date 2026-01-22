-- Trigger: Bigby Assistant refuse
-- Zone: 30, ID: 92
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3092

-- Converted from DG Script #3092: Bigby Assistant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
_return_value = false
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
self:command("shake")
self:say("I don't need this.")
return _return_value