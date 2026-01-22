-- Trigger: Moonwell receive decline
-- Zone: 163, ID: 64
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16364

-- Converted from DG Script #16364: Moonwell receive decline
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("moonwell_spell_quest")
if (stage == 1 or stage == 2 or stage == 3) and object.id == 16350 then
    return _return_value
elseif (stage == 3 or stage == 4) and object.id == 48024 then
    return _return_value
elseif (stage == 4 or stage == 5 or stage == 6) and object.id == 16356 then
    return _return_value
elseif stage == 6 and object.id == 5201 then
    return _return_value
elseif stage == 7 and (object.id == 16006 or object.id == 16351) then
    return _return_value
elseif stage == 8 and object.id == 16352 then
    return _return_value
elseif stage == 9 and object.id == 49011 then
    return _return_value
elseif stage == 10 and (object.id == 4003 or object.id == 16353) then
    return _return_value
elseif stage == 11 and (object.id == 55020 or object.id == 16354 or object.id == 16355) then
    return _return_value
else
    _return_value = false
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I do not want this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value