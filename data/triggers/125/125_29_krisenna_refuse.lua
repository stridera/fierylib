-- Trigger: Krisenna refuse
-- Zone: 125, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12529

-- Converted from DG Script #12529: Krisenna refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
self:command("snarl " .. tostring(actor))
self:say("You try to appease me with trinkets?  Bah.")
return _return_value