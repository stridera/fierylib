-- Trigger: Green Woman refuse
-- Zone: 60, ID: 33
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6033

-- Converted from DG Script #6033: Green Woman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("wizard_eye") == 7 then
    -- switch on object.id
    if object.id == 23754 or object.id == 3298 or object.id == 23847 or object.id == 18001 then
        return _return_value
    else
        -- default (typo: defalt)
        local response = "This " .. tostring(object.shortdesc) .. " isn't roses or cinnamon."
    end
else
    local response = "I only take coin, not trade."
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value