-- Trigger: Bigby Assistant refuse
-- Zone: 30, ID: 92
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3092

-- Converted from DG Script #3092: Bigby Assistant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (300 310 320 330 55577 55575 55574 55576) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 2 and object.id == 100)
    or (object.zone_id == 2 and object.id == 110)
    or (object.zone_id == 2 and object.id == 120)
    or (object.zone_id == 2 and object.id == 130)
    or (object.zone_id == 555 and object.id == 77)
    or (object.zone_id == 555 and object.id == 75)
    or (object.zone_id == 555 and object.id == 74)
    or (object.zone_id == 555 and object.id == 76) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:command("shake")
    self:say("I don't need this.")
end
return _return_value