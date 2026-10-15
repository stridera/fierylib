-- Trigger: Sculptor refuse
-- Zone: 533, ID: 14
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #53314
--
-- Refuses generic items the sculptor cannot use. The ice wand's step 7 items (wandgem, wandtask3,
-- wandtask4, wand_id, exported through `globals` by 002_111) are left to 002_108, and 533:27
-- (53327, the arg list) to its own trigger; the rest is turned away with a message that depends
-- on which quests the player is on. A turned-away item is handed back, the way legacy `return 0`
-- refused a receive.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 533 and object.id == 27 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end

local wand_quest = (globals.type or "type") .. "_wand"
local on_wand = globals.wandstep ~= nil and actor:get_quest_stage(wand_quest) == globals.wandstep
local on_wall = actor:get_quest_stage("wall_ice") > 0
local response
if on_wall and on_wand then
    response = "This won't help us build this wall and I can't craft with it."
elseif on_wand then
    response = "I can't craft with this."
elseif on_wall then
    response = "This won't help us build this wall."
else
    response = "What is this for?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(response)
return false  -- legacy return 0: the giver keeps the item
