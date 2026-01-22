-- Trigger: megalith_priestess_refuse
-- Zone: 123, ID: 43
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12343

-- Converted from DG Script #12343: megalith_priestess_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("megalith_quest")
if stage ~= 1 and stage ~= 3 then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    local response = "I need your help with something else."
elseif stage == 1 then
    -- switch on object.id
    if object.id == 23756 or object.id == 41111 or object.id == 41110 or object.id == 18512 or object.id == 8507 or object.id == 17300 or object.id == 8612 or object.id == 58809 then
        return _return_value
    else
        local response = "Unfortunately, that's not going to help empower the ritual."
    end
elseif stage == 3 then
    -- switch on object.id
    if object.id == 23817 or object.id == 4305 or object.id == 4318 or object.id == 58015 or object.id == 58018 or object.id == 58426 or object.id == 58418 then
        return _return_value
    else
        local response = "Unfortunately, that's not going to help empower the ritual."
    end
end
if response then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say(tostring(response))
end
return _return_value