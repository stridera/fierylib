-- Trigger: phase wand general death
-- Zone: 2, ID: 112
-- Type: MOB, Flags: DEATH
--
-- When one of the eight stage 9/10 boss mobs dies, every group member
-- present at the kill site who is on the matching <type>_wand quest at
-- the right stage gets credit for the final crafting task — wandtask4
-- at stage 9, wandtask3 at stage 10.
--
-- The wand names print through dg.oname (the wands are zone-2 objects, 307 = 2:107). The group is
-- actor.group_member (1-based, the killer included; just the killer when solo).
local dg = require("dg")
local quest_type, color, wand_id, stage_target, task_key
if (self.zone_id == 238 and self.id == 3) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 307, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 1) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 308, 10, "wandtask3"
elseif (self.zone_id == 40 and self.id == 13) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 317, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 2) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 318, 10, "wandtask3"
elseif (self.zone_id == 533 and self.id == 0) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 327, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 5) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 328, 10, "wandtask3"
elseif (self.zone_id == 520 and self.id == 18) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 337, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 7) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 338, 10, "wandtask3"
end
if not quest_type then return end

local quest = quest_type .. "_wand"

local function credit(person)
    if not person.is_player then return end
    if person.room ~= self.room then return end
    if person:get_quest_stage(quest) ~= stage_target then return end
    if dg.flag(person:get_quest_var(quest .. ":" .. task_key)) then return end
    person:set_quest_var(quest, task_key, 1)
    person:send(color .. dg.oname(wand_id) .. " crackles with vibrant energy!</>")
    person:send(color .. "It is primed for reforging!</>")
end

local members = actor.group_member
if members and #members > 0 then
    for _, person in ipairs(members) do
        credit(person)
    end
else
    credit(actor)
end
