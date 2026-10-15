-- Trigger: Earle receive sapling
-- Zone: 490, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49029

-- Converted from DG Script #49029: Earle receive sapling
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49045): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 45)
) then
    return true
end

-- sapling given back
self:say("Keep it, " .. tostring(actor.name) .. "!  You'll need to drop it by the altar.  Otherwise you will never defeat Dagon's material form!")
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return false  -- legacy return 0: the giver keeps the item
