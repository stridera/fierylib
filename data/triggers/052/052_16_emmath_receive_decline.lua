-- Trigger: Emmath receive decline
-- Zone: 52, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5216
--
-- Catch-all decline message Emmath gives when handed the wrong item.
-- Legacy DG receive trigger with num_arg 0: it fires for every item that is
-- not on its arg list (the items the specific receive handlers take). Picks the response from the
-- most specific outstanding quest stage.

-- DG receive trigger, num_arg 0: the arg list (5211 5212 17308 23822 318) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 52 and object.id == 11)
    or (object.zone_id == 52 and object.id == 12)
    or (object.zone_id == 173 and object.id == 8)
    or (object.zone_id == 238 and object.id == 22)
    or (object.zone_id == 2 and object.id == 118) then
    return true
end

local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
local wand_quest = (globals.type or "type") .. "_wand"
local stage_subclass = actor:get_quest_stage("pyromancer_subclass") or 0
local response
if stage_subclass > 0 and stage_subclass <= 4 then
    response = "I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame, not this nonsense."
elseif globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    response = "I can't craft with this!"
elseif (actor:get_quest_stage("emmath_flameball") or 0) > 1 then
    response = "You're supposed to be out collecting flames, not whatever this is."
else
    response = "Why are you bringing me this trash?"
end

dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
return true