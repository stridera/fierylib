-- Trigger: Treant refuse
-- Zone: 625, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62505

-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- TODO(parity): The legacy script's RECEIVE filter referenced three
-- variable IDs (%wandgem%, %wand_id%, %wandtask3%) that came from a
-- separate phase-wand quest's load script and are not in scope here.
-- DG num_arg 0 = every item not on the arg list (62504), which is excluded below.

-- DG receive trigger, num_arg 0: the arg list (62504) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 625 and object.id == 4) then
    return true
end
wait(1)
self:command("grumble")
self:command("drop " .. tostring(object))
