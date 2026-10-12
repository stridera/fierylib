-- Trigger: Timulos refuse
-- Zone: 60, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6024

-- Converted from DG Script #6024: Timulos refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (41014 3033 8813) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 410 and object.id == 14)
    or (object.zone_id == 30 and object.id == 33)
    or (object.zone_id == 88 and object.id == 13) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
local response
if actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.  Now go bring me what you were told.'")
    world.destroy(object)
else
    response = "What is this? Are you trying to trick me?"
end
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value