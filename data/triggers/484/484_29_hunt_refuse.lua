-- Trigger: Hunt refuse
-- Zone: 484, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48429

-- Converted from DG Script #48429: Hunt refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (48429) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
local response
if (object.zone_id == 484 and object.id == 29) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    response = "Why do you bother the Goddess of the Hunt?"
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value