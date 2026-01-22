-- Trigger: Seer refuse
-- Zone: 490, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: %action%
--
-- Original DG Script: #49022

-- Converted from DG Script #49022: Seer refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
    if actor:get_quest_stage("wizard_eye") == 4 then
    elseif object.id == 2329 or object.id == 23753 or object.id == 48005 then
        return _return_value
    else
        local response = "This isn't sunscreen, what use do I have for it?"
    end
else
    if actor:get_quest_stage("wizard_eye") == 4 then
        local response = "This isn't a dress, bay, or thyme!  I don't have thyme for this!"
        local action = "cackle"
    else
        local response = "This isn't sunscreen, what use do I have for it?"
    end
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    if action then
        -- UNCONVERTED: %action%
    end
end
return _return_value