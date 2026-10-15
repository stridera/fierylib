-- Trigger: Master Shaman refuse
-- Zone: 550, ID: 8
-- Type: MOB, Flags: RECEIVE
--
-- Default refusal handler: when the Master Shaman is given an item that
-- doesn't match the current Wizard Eye stage's expected ingredient, she
-- refuses it with a stage-appropriate quip.
--
-- The wand-quest items (wandgem, wand_id, wandtask3, exported through `globals` by 002_111) fall
-- through to 002_108, and so does the ingredient of the player's current Wizard Eye stage (58609
-- at stage 2, 55030 at 5, 55032 at 8, 55033 at 11 = 586:9, 550:30, 550:32, 550:33).
-- A turned-away item is handed back, the way legacy `return 0` refused a receive.
--
-- Original DG Script: #55008

-- Converted from DG Script #55008: Master Shaman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (55005 55023) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 550 and object.id == 5)
    or (object.zone_id == 550 and object.id == 23) then
    return true
end
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
local stage = actor:get_quest_stage("wizard_eye")
if (stage == 2 and object.zone_id == 586 and object.id == 9)
    or (stage == 5 and object.zone_id == 550 and object.id == 30)
    or (stage == 8 and object.zone_id == 550 and object.id == 32)
    or (stage == 11 and object.zone_id == 550 and object.id == 33) then
    return true
end
local desc = tostring(object.shortdesc)
local response
if stage == 2 then
    response = "Is " .. desc .. " really what she sent you to find?"
elseif stage == 5 or stage == 8 then
    response = "Is " .. desc .. " really what she suggested you use?"
elseif stage == 11 then
    response = "What?  " .. desc .. "?  This can't be right."
else
    response = "What is this?"
end
self:command("eye " .. tostring(actor.name))
actor:send(tostring(self.name) .. " says, '" .. response .. "'")
self.room:send(tostring(self.name) .. " refuses " .. desc .. ".")
return false  -- legacy return 0: the giver keeps the item