-- Trigger: mage_receive_refuse
-- Zone: 238, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23808

-- Converted from DG Script #23808: mage_receive_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandvnum%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" then
    return _return_value
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
end
return _return_value