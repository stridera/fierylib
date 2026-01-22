-- Trigger: Master Shaman refuse
-- Zone: 550, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #55008

-- Converted from DG Script #55008: Master Shaman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("wizard_eye")
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandvnum%" or object.id == "%wandtask3%" then
    return _return_value
    if stage == 2 then
    elseif object.id == 58609 then
        return _return_value
    end
    if stage == 5 then
    elseif object.id == 55030 then
        return _return_value
    end
    if stage == 8 then
    elseif object.id == 55032 then
        return _return_value
    end
    if stage == 11 then
    elseif object.id == 55033 then
        return _return_value
    end
end
if stage == 2 then
    local response = Is object.shortdesc really what she sent you to find?
elseif stage == 5 or stage == 8 then
    local response = Is object.shortdesc really what she suggested you use?
elseif stage == 11 then
    local response = What?  object.shortdesc?  This can't be right.
else
    local response = "What is this?"
end
if response then
    _return_value = false
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value