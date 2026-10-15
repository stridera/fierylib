-- Trigger: Eleweiss refuse
-- Zone: 163, ID: 10
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16310
--
-- Catch-all RECEIVE handler for Eleweiss, the acid wand's step 10 crafter: anything that is not a
-- wand-quest item (wandgem, wand_id, exported through `globals` by 002_111) is refused.
--
-- DG receive trigger, num_arg 0: the arg list (17212 = 172:12) holds the item other triggers
-- handle; this one runs for every other item. A turned-away item is handed back, the way legacy
-- `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 172 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this?'")
wait(0.3)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'I have no need of " .. tostring(object.shortdesc) .. ".'")
return true
