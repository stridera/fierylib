-- Trigger: collar-shock
-- Zone: 237, ID: 6
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #23706

-- Converted from DG Script #23706: collar-shock
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    actor:damage(15)  -- type: physical
    actor:send("The collar shocks you as you try to remove it!")
    self.room:send_except(actor, "As " .. tostring(actor.name) .. " reaches for a slave collar, " .. tostring(actor.name) .. " suddenly spasms, arms lolling.")
    _return_value = false
end
return _return_value