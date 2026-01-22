-- Trigger: Guild Master refuse
-- Zone: 557, ID: 6
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55706

-- Converted from DG Script #55706: Guild Master refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
-- switch on object.id
if object.id == "%maceitem2%" or object.id == "%maceitem3%" or object.id == "%maceitem4%" or object.id == "%maceitem5%" or object.id == "%macevnum%" then
    return _return_value
end
-- switch on object.id
if object.id == 55662 or object.id == 2334 then
    return _return_value
end
-- switch on object.id
if object.id == "%hands_armor%" or object.id == "%hands_gem%" or object.id == "%feet_armor%" or object.id == "%feet_gem%" or object.id == "%wrist_armor%" or object.id == "%wrist_gem%" or object.id == "%head_armor%" or object.id == "%head_gem%" or object.id == "%arms_armor%" or object.id == "%arms_gem%" or object.id == "%legs_armor%" or object.id == "%legs_gem%" or object.id == "%body_armor%" or object.id == "%body_gem%" then
    return _return_value
else
    _return_value = false
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value