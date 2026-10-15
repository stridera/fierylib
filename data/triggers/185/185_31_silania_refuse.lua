-- Trigger: silania_refuse
-- Zone: 185, ID: 31
-- Type: MOB, Flags: RECEIVE
--
-- Silania refuses any object not tied to the wand/mace upgrade quests: she is the air wand's
-- step 10 crafter and the mace's step 6 priest, so the items of both (wandgem, wand_id, maceitem2..5,
-- mace_id, exported through `globals` by 002_111 and 002_118) go to 002_108 and 002_126.
--
-- DG receive trigger, num_arg 0: the arg list (18512 = 185:12) holds the item other triggers
-- handle; this one runs for every other item. A turned-away item is handed back, the way legacy
-- `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 185 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return false  -- legacy return 0: the giver keeps the item
