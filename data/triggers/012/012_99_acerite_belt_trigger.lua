-- Trigger: Acerite_belt_trigger
-- Zone: 12, ID: 99
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #1299

-- Converted from DG Script #1299: Acerite_belt_trigger
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor.can_be_seen and actor.level < 100 then
    _return_value = false
    actor:send("The broad silver belt flares white, burning you as you attempt to remove it!")
    self.room:send_except(actor, "A broad silver belt flares and lets off smoke as " .. tostring(actor.name) .. " reaches for its buckle.")
    actor:damage(100)  -- type: fire
end
return _return_value