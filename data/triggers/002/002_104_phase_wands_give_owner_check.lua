-- Trigger: phase wands give owner check
-- Zone: 2, ID: 104
-- Type: OBJECT, Flags: GIVE
--
-- Refuses giving a phase wand/staff to the wrong questmaster. Each crafter
-- mob is mapped to a (type, wandstep) pair; the wand's id range identifies
-- the player's element. Refusal happens if either the type is wrong (mob
-- crafts a different element) or the player isn't yet at the right step.
-- For npc victims not in the table, the script blocks the give entirely.
--
-- TODO(parity): victim ids are legacy 5-digit vnums. Migrate to
-- (victim.zone_id, victim.local_id) once the proper mapping is restored.
local _return_value = true  -- Default: allow action

local energy
if self.id >= 300 and self.id <= 309 then
    energy = "air"
elseif self.id >= 310 and self.id <= 319 then
    energy = "fire"
elseif self.id >= 320 and self.id <= 329 then
    energy = "ice"
elseif self.id >= 330 and self.id <= 339 then
    energy = "acid"
end

local crafter_type, wandstep
if victim.id == 18500 then crafter_type, wandstep = "air", 3
elseif victim.id == 4126  then crafter_type, wandstep = "fire", 3
elseif victim.id == 17806 then crafter_type, wandstep = "ice", 3
elseif victim.id == 10056 then crafter_type, wandstep = "acid", 3
elseif victim.id == 58601 then crafter_type, wandstep = "air", 4
elseif victim.id == 10306 then crafter_type, wandstep = "fire", 4
elseif victim.id == 2337  then crafter_type, wandstep = "ice", 4
elseif victim.id == 62504 then crafter_type, wandstep = "acid", 4
elseif victim.id == 12305 then crafter_type, wandstep = "air", 5
elseif victim.id == 12304 then crafter_type, wandstep = "fire", 5
elseif victim.id == 55013 then crafter_type, wandstep = "ice", 5
elseif victim.id == 62503 then crafter_type, wandstep = "acid", 5
elseif victim.id == 12302 then crafter_type, wandstep = "air", 6
elseif victim.id == 23811 then crafter_type, wandstep = "fire", 6
elseif victim.id == 23802 then crafter_type, wandstep = "ice", 6
elseif victim.id == 47075 then crafter_type, wandstep = "acid", 6
elseif victim.id == 49003 then crafter_type, wandstep = "air", 7
elseif victim.id == 48105 then crafter_type, wandstep = "fire", 7
elseif victim.id == 53316 then crafter_type, wandstep = "ice", 7
elseif victim.id == 4017  then crafter_type, wandstep = "acid", 7
elseif victim.id == 8515  then crafter_type, wandstep = "air", 8
elseif victim.id == 48250 then crafter_type, wandstep = "fire", 8
elseif victim.id == 10300 then crafter_type, wandstep = "ice", 8
elseif victim.id == 48029 then crafter_type, wandstep = "acid", 8
elseif victim.id == 6216  then crafter_type, wandstep = "air", 9
elseif victim.id == 48412 then crafter_type, wandstep = "fire", 9
elseif victim.id == 10012 then crafter_type, wandstep = "ice", 9
elseif victim.id == 3549  then crafter_type, wandstep = "acid", 9
elseif victim.id == 18581 then crafter_type, wandstep = "air", 10
elseif victim.id == 5230  then crafter_type, wandstep = "fire", 10
elseif victim.id == 55020 then crafter_type, wandstep = "ice", 10
elseif victim.id == 16315 then crafter_type, wandstep = "acid", 10
end

if not actor.is_player or not crafter_type or not energy then
    return _return_value
end

local quest = energy .. "_wand"
local refuse
if crafter_type ~= energy then
    refuse = 1
elseif (actor:get_quest_stage(quest) or 0) < wandstep then
    refuse = 2
end

local weapon = (wandstep >= 8) and "staff" or "wand"
if refuse == 1 then
    actor:send("You shouldn't give away something so precious!")
elseif refuse == 2 then
    self.room:send(tostring(victim.name) .. " refuses " .. tostring(self.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(victim.name) .. " tells you, 'This isn't yours!  I can't help you properly improve with a " .. weapon .. " that doesn't belong to you.'")
end
return _return_value
