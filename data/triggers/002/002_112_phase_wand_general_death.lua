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
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
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
    if person.room ~= self.room then return end
    if person:get_quest_stage(quest) ~= stage_target then return end
    if person:get_quest_var(quest .. ":" .. task_key) then return end
    person:set_quest_var(quest, task_key, 1)
    person:send(color .. proto_short(wand_id) .. " crackles with vibrant energy!</>")
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
