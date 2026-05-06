-- Trigger: Justice refuse
-- Zone: 484, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <Justice refuse>:10: syntax error near 'can'
--
-- Original DG Script: #48428

-- Converted from DG Script #48428: Justice refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- `response` is set inside the branches below; declared here so
-- both the outer if/else and the inner else can write to the
-- same binding (the converter emitted `local response = ...`
-- inside each branch, scoping each to its branch and breaking
-- the post-block `if response then` test).
local response = nil
if actor:get_quest_stage("wizard_eye") == 10 then
    if object.id == 3218 or object.id == 53424 or object.id == 43021 or object.id == 4003 then
        return _return_value
    else
        response = "This " .. tostring(object.shortdesc) .. " can't possibly be what you needed to ask me about."
    end
else
    response = "I'm sorry, do you need something?"
end
if response then
    _return_value = true
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value