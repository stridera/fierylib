-- Trigger: Rhell merchant refuse
-- Zone: 625, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62519

-- Converted from DG Script #62519: Rhell merchant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_has_completed("ursa_quest") then
    local response = "I don't really need this."
elseif not actor:get_quest_stage("ursa_quest") then
    local response = "I don't think this will help me."
elseif actor:get_quest_stage("ursa_quest") == 1 then
    -- switch on object.id
    if object.id == 62511 or object.id == 62510 or object.id == 62512 then
        return _return_value
    else
        local response = "This isn't helpful."
    end
end
if not response then
    return _return_value
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    self:say(tostring(response))
    if actor:get_quest_stage("ursa_quest") == 1 then
        wait(2)
        self:say("Maybe you could ask someone who might know.")
    end
end
return _return_value