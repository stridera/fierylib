-- Trigger: Grand Master refuse
-- Zone: 172, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #17219

-- Converted from DG Script #17219: Grand Master refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
_return_value = false
wait(1)
actor:send(tostring(self.name) .. " says, 'Eh?  Err... no thank you.'")
wait(2)
actor:send(tostring(self.name) .. " returns your gift.")  -- typo: mechoto
self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(actor.name) .. "'s gift.")
return _return_value