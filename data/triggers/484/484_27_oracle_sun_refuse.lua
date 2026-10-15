-- Trigger: Oracle Sun refuse
-- Zone: 484, ID: 27
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #48427
--
-- The Oracle of the Sun is the fire wand's step 9 crafter and the mace's step 8 priest. The items
-- of both quests (wandgem, wandtask3, wandtask4, wand_id, maceitem2..5, mace_id, exported through
-- `globals` by 002_111 and 002_118) go to 002_108 and 002_126; anything else is handed back.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'I have no need of this.'")
return false  -- legacy return 0: the giver keeps the item
