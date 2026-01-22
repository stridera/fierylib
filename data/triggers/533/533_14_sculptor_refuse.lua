-- Trigger: Sculptor refuse
-- Zone: 533, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53314

-- Converted from DG Script #53314: Sculptor refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
else
    if actor:get_quest_stage("wall_ice") and actor.quest_stage[type_wand] == "wandstep" then
        local response = "This won't help us build this wall and I can't craft with it."
    elseif actor.quest_stage[type_wand] == "wandstep" then
        local response = "I can't craft with this."
    elseif actor:get_quest_stage("wall_ice") then
        local response = "This won't help us build this wall."
    else
        local response = "What is this for?"
    end
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say(tostring(response))
end
return _return_value