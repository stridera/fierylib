-- Trigger: McCabe refuse
-- Zone: 481, ID: 149
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #48249
--
-- DG receive trigger, num_arg 0: the arg list (48252 48251 = 481:152, 481:151) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. McCabe is the fire wand's step 8 crafter: the wand items
-- (wandgem, wandtask3, wandtask4, wand_id, exported through `globals` by 002_111) go to 002_108.
-- A turned-away item is handed back, the way legacy `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if (object.zone_id == 481 and object.id == 152) or (object.zone_id == 481 and object.id == 151) then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
self:command("eye")
actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
return false  -- legacy return 0: the giver keeps the item
