-- Trigger: Treant refuse
-- Zone: 625, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62505

-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- The wand-quest items (wandgem, wand_id, wandtask3, exported through `globals` by 002_111) fall
-- through to 002_108.
-- DG receive trigger, num_arg 0: the arg list (62504) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if (object.zone_id == 625 and object.id == 4) then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
wait(1)
self:command("grumble")
self:command("drop " .. tostring(object.alias))
