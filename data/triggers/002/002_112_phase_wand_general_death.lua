-- Trigger: phase wand general death
-- Zone: 2, ID: 112
-- Type: MOB, Flags: DEATH
--
-- When one of the eight stage 9/10 boss mobs dies, every group member
-- present at the kill site who is on the matching <type>_wand quest at
-- the right stage gets credit for the final crafting task — wandtask4
-- at stage 9, wandtask3 at stage 10.
--
-- TODO(parity): Embedded `%get.obj_shortdesc[%wand_id%]%` interpolations
-- are preserved as-is in the player notification strings. Replace each
-- with `objects.template(2, wand_id % 100).name` once the wand id table
-- is wired through globals or a binding helper.
local quest_type, color, wand_id, stage_target, task_key
if self.id == 23803 then
    quest_type, color, wand_id, stage_target, task_key = "air", "&7&b", 307, 9, "wandtask4"
elseif self.id == 52001 then
    quest_type, color, wand_id, stage_target, task_key = "air", "&7&b", 308, 10, "wandtask3"
elseif self.id == 4013 then
    quest_type, color, wand_id, stage_target, task_key = "fire", "&1", 317, 9, "wandtask4"
elseif self.id == 52002 then
    quest_type, color, wand_id, stage_target, task_key = "fire", "&1", 318, 10, "wandtask3"
elseif self.id == 53300 then
    quest_type, color, wand_id, stage_target, task_key = "ice", "&6&b", 327, 9, "wandtask4"
elseif self.id == 52005 then
    quest_type, color, wand_id, stage_target, task_key = "ice", "&6&b", 328, 10, "wandtask3"
elseif self.id == 52018 then
    quest_type, color, wand_id, stage_target, task_key = "acid", "&2&b", 337, 9, "wandtask4"
elseif self.id == 52007 then
    quest_type, color, wand_id, stage_target, task_key = "acid", "&2&b", 338, 10, "wandtask3"
end
if not quest_type then return end

local quest = quest_type .. "_wand"

local function credit(person)
    if person.room ~= self.room then return end
    if person:get_quest_stage(quest) ~= stage_target then return end
    if person:get_quest_var(quest .. ":" .. task_key) then return end
    person:set_quest_var(quest, task_key, 1)
    person:send(color .. "%get.obj_shortdesc[%wand_id%]% crackles with vibrant energy!</>")
    person:send(color .. "It is primed for reforging!</>")
end

local group = actor.group
if group and #group > 0 then
    for _, person in ipairs(group) do
        credit(person)
    end
else
    credit(actor)
end
