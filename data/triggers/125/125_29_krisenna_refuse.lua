-- Trigger: Krisenna refuse
-- Zone: 125, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12529

-- Converted from DG Script #12529: Krisenna refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
-- DG receive arg list (55739 2339) with num_arg 0: this trigger ran for every other item.
-- The runtime does not filter on arg_list, so the exclusion lives here.
if (object.zone_id == 557 and object.id == 39) or
    (object.zone_id == 23 and object.id == 39) then
    return true
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:command("snarl " .. tostring(actor.name))
self:say("You try to appease me with trinkets?  Bah.")
return false  -- legacy return 0: the giver keeps the item