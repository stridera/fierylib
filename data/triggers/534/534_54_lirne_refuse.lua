-- Trigger: Lirne Refuse
-- Zone: 534, ID: 54
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53454

-- Converted from DG Script #53454: Lirne Refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
-- NOTE: legacy probability 0% on RECEIVE means "always run", not "never";
-- the converter's percent_chance(0) gate has been removed.

-- Lirne refuses any item handed to him that isn't the right ingredient for
-- his current quest stage. The salve/sake/marigold quest items belong with
-- Earle, not Lirne, so they get a redirect message; everything else gets a
-- generic "no thanks".
-- DG receive arg list (53450 53452 53453 53454 53455 53456 53457 53458 53459 53460 53461) with num_arg 0: this trigger ran for every other item.
-- The runtime does not filter on arg_list, so the exclusion lives here.
if (object.zone_id == 534 and object.id == 50) or
    (object.zone_id == 534 and object.id == 52) or
    (object.zone_id == 534 and object.id == 53) or
    (object.zone_id == 534 and object.id == 54) or
    (object.zone_id == 534 and object.id == 55) or
    (object.zone_id == 534 and object.id == 56) or
    (object.zone_id == 534 and object.id == 57) or
    (object.zone_id == 534 and object.id == 58) or
    (object.zone_id == 534 and object.id == 59) or
    (object.zone_id == 534 and object.id == 60) or
    (object.zone_id == 534 and object.id == 61) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
-- TODO(parity): legacy DG checked object vnums 53451 (shale, zone 534/id 51),
-- 58002 (sake, zone 580/id 2), 58609 (marigold poultice, zone 586/id 9). The
-- converter incorrectly nested stage==3 / stage==4 inside the stage==2 branch
-- and lost the redirect message for stages 3 and 4. Reconstructed below using
-- composite (zone_id, local_id) checks; verify zone numbers against the
-- canonical ingredient definitions.
local response = "No thanks."
if stage == 2 then
    if object.zone_id == 534 and object.local_id == 51 then
        response = "Give this to Earle, not me."
    end
elseif stage == 3 then
    if object.zone_id == 580 and object.local_id == 2 then
        response = "Give this to Earle, not me."
    end
elseif stage == 4 then
    if object.zone_id == 586 and object.local_id == 9 then
        response = "Give this to Earle, not me."
    end
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(response)
return false  -- legacy return 0: the giver keeps the item