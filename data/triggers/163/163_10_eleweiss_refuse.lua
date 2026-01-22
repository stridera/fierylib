-- Trigger: Eleweiss refuse
-- Zone: 163, ID: 10
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16310

-- Converted from DG Script #16310: Eleweiss refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandvnum%" then
    return _return_value
else
    _return_value = false
    wait(2)
    actor:send(tostring(self.name) .. " says, 'What is this?'")
    wait(3)
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I have no need of " .. tostring(object.shortdesc) .. ".'")
end
return _return_value