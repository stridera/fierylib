-- Trigger: Oracle Sun refuse
-- Zone: 484, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48427

-- Converted from DG Script #48427: Oracle Sun refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%maceitem2%" or object.id == "%maceitem3%" or object.id == "%maceitem4%" or object.id == "%maceitem5%" or object.id == "%macevnum%" or object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
else
    local response = "I have no need of this."
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value