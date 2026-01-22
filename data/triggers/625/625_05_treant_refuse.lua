-- Trigger: Treant refuse
-- Zone: 625, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62505

-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandvnum%" or object.id == "%wandtask3%" then
    return _return_value
else
    wait(1)
    self:command("grumble")
    self:command("drop " .. tostring(object))
end