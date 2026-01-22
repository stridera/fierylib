-- Trigger: Sculptor refuse
-- Zone: 533, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
-- Fixed: Removed broken phase wand references, fixed variable scoping for response
--
-- Original DG Script: #53314

-- Converted from DG Script #53314: Sculptor refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
local response = nil

-- Note: Phase wand item acceptance logic removed - handled by generic phase wand triggers
if actor:get_quest_stage("wall_ice") then
    response = "This won't help us build this wall."
else
    response = "What is this for?"
end

if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say(response)
end
return _return_value