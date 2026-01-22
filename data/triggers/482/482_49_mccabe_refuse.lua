-- Trigger: McCabe refuse
-- Zone: 482, ID: 49
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48249

-- Converted from DG Script #48249: McCabe refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
else
    _return_value = false
    self:command("eye")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
end
return _return_value