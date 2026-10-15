-- Trigger: sexton_refuse
-- Zone: 185, ID: 29
-- Type: MOB, Flags: RECEIVE
--
-- The Sexton (macestep 2) turns away any object that is not part of the phase_mace upgrade: the
-- mace (mace_id), the materials (maceitem2..5) and the pilgrimage dirt (maceitem6), all exported
-- through `globals` by 002_118 and handled by the receive trigger 002_126. A turned-away item is
-- handed back, the way legacy `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'I'm sorry, what is this for?'")
return true
