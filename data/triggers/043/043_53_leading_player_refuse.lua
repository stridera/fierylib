-- Trigger: Leading Player refuse
-- Zone: 43, ID: 53
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4353

-- Converted from DG Script #4353: Leading Player refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (4357) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 43 and object.id == 57) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    if actor:get_quest_stage("bard_subclass") == 4 then
        actor:send(tostring(self.name) .. " says, 'This isn't the script I sent you for.'")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'I sure hope you didn't memorize anything from that!'")
        return false  -- legacy return 0: the giver keeps the item
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
        return false  -- legacy return 0: the giver keeps the item
    end
end
return _return_value