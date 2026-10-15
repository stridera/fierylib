-- Trigger: Magistrate refuse
-- Zone: 30, ID: 35
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3035

-- Converted from DG Script #3035: Magistrate refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (55211 55577 13614 58809 16023 340) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 552 and object.id == 11)
    or (object.zone_id == 555 and object.id == 77)
    or (object.zone_id == 136 and object.id == 14)
    or (object.zone_id == 588 and object.id == 9)
    or (object.zone_id == 160 and object.id == 23)
    or (object.zone_id == 2 and object.id == 140) then
    return true
end
-- switch on objet.id
do
    wait(0.1)
    self:say("Thanks!")
end