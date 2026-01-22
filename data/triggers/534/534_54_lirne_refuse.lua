-- Trigger: Lirne Refuse
-- Zone: 534, ID: 54
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #53454

-- Converted from DG Script #53454: Lirne Refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
-- switch on object.id
if stage == 2 then
    if object.id == 53451 then
        local response = "Give this to Earle, not me."
    else
        local response = "No thanks."
    end
    if stage == 3 then
    elseif object.id == 58002 then
        local response = "Give this to Earle, not me."
    else
        local response = "No thanks."
    end
    if stage == 4 then
    elseif object.id == 58609 then
        local response = "Give this to Earle, not me."
    else
        local response = "No thanks."
    end
else
    local response = "No thanks."
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say(tostring(response))
end
return _return_value