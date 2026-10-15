-- Trigger: Ziijhan general receive
-- Zone: 85, ID: 26
-- Type: MOB, Flags: RECEIVE
--
-- Default RECEIVE handler for Ziijhan: turns away any item that is not part of the phase mace
-- upgrade chain.
--
-- Original DG Script: #8526
--
-- DG receive trigger, num_arg 0: the arg list (8504) holds the item other triggers handle (85:4);
-- this one runs for every other item. The runtime does not filter on arg_list, so the exclusion
-- lives here. Ziijhan is the macestep 5 priest: the mace and its materials (maceitem2..5, mace_id,
-- exported through `globals` by 002_118) go to the receive trigger 002_126. A turned-away item is
-- handed back, the way legacy `return 0` refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 85 and object.id == 4 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
actor:send(tostring(self.name) .. " scoffs at " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this garbage?'")
return true
