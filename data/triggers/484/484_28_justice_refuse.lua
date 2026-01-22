-- Trigger: Justice refuse
-- Zone: 484, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48428

-- Converted from DG Script #48428: Justice refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("wizard_eye") == 10 then
    -- switch on object.id
    if object.id == 3218 or object.id == 53424 or object.id == 43021 or object.id == 4003 then
        return _return_value
    else
        local response = This get.obj_noadesc[object.vnum] can't possibly be what you needed to ask me about.
    end
else
    local response = "I'm sorry, do you need something?"
end
if response then
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value