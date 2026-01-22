-- Trigger: pool_of_chems_hurts
-- Zone: 16, ID: 4
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #1604

-- Converted from DG Script #1604: pool_of_chems_hurts
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
local var1 = random(1, 12)
local damage = 10 + var1
local damage_dealt = actor:damage(damage)  -- type: acid
if damage_dealt == 0 then
    actor:send("The chemicals dribble through your fingers back into the pool.")
    self.room:send_except(actor, tostring(actor.name) .. " tries to pick up the chemicals, but they dribble through " .. tostring(actor.possessive) .. " fingers.")
else
    actor:send("OUCH! The chemicals burn as they drip through your fingers. (<green>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " yelps as " .. tostring(actor.possessive) .. " fingers are burned by some chemicals. (<green>" .. tostring(damage_dealt) .. "</>)")
end
_return_value = false
return _return_value