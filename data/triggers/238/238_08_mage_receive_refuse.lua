-- Trigger: mage_receive_refuse
-- Zone: 238, ID: 8
-- Type: MOB, Flags: RECEIVE
--
-- The mage (the ice wand's step 6 crafter) refuses any object that is not one of the wand-craft
-- quest items (wandgem, wand_id, wandtask3, wandtask4, exported through `globals` by 002_111).
--
-- DG receive trigger, num_arg 0: the arg list (23822 = 238:22) holds the item the accept path
-- (238_15_mage_receive.lua) handles; this one runs for every other item. A turned-away item is
-- handed back, the way legacy `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 238 and object.id == 22 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return true
