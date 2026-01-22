-- Trigger: Hunt refuse
-- Zone: 484, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48429

-- Converted from DG Script #48429: Hunt refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
local response = "Why do you bother the Goddess of the Hunt?"
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value