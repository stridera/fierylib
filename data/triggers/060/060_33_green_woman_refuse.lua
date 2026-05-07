-- Trigger: Green Woman refuse
-- Zone: 60, ID: 33
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #6033

-- Converted from DG Script #6033: Green Woman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- `response` is hoisted so the inner else and the outer else
-- can both write to the same binding. The converter emitted
-- `local` per branch; the post-block test below would never see
-- those values.
local response = nil
if actor:get_quest_stage("wizard_eye") == 7 then
    if object.id == 23754 or object.id == 3298 or object.id == 23847 or object.id == 18001 then
        return _return_value
    else
        response = "This " .. tostring(object.shortdesc) .. " isn't roses or cinnamon."
    end
else
    response = "I only take coin, not trade."
end
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value