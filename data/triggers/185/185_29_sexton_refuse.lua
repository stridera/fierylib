-- Trigger: Sexton refuse
-- Zone: 185, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #18529

-- Converted from DG Script #18529: Sexton refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%maceitem2%" or object.id == "%maceitem3%" or object.id == "%maceitem4%" or object.id == "%maceitem5%" or object.id == "%macevnum%" or object.id == "%maceitem6%" then
    return _return_value
else
    local response = "I'm sorry, what is this for?"
end
if response then
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value