-- Trigger: assassin_subclass_guards_can_see
-- Zone: 60, ID: 30
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6030

-- Converted from DG Script #6030: assassin_subclass_guards_can_see
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: up
if not (cmd == "up") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.can_be_seen and actor.hiddenness < 1 then
    actor:send(tostring(self.name) .. " cuts you off from the stairs.")
    actor:send(tostring(self.name) .. " asks you, 'Do you have an appointment?'")
    self.room:send_except(actor, tostring(self.name) .. " stands in " .. tostring(actor.name) .. "'s way.")
else
    _return_value = false
end
return _return_value