-- Trigger: Timulos refuse
-- Zone: 60, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6024

-- Converted from DG Script #6024: Timulos refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.  Now go bring me what you were told.'")
    world.destroy(object)
else
    local response = "What is this? Are you trying to trick me?"
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value