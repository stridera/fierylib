-- Trigger: Ziijhan general receive
-- Zone: 85, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #8526

-- Converted from DG Script #8526: Ziijhan general receive
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%maceitem2%" or object.id == "%maceitem3%" or object.id == "%maceitem4%" or object.id == "%maceitem5%" or object.id == "%macevnum%" then
    return _return_value
else
    local response = "What is this garbage?"
end
if response then
    _return_value = false
    actor:send(self.name .. " scoffs at " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value