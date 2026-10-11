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
if (victim.zone_id == 185 and victim.id == 0) then crafter_type, wandstep = "air", 3
elseif (victim.zone_id == 41 and victim.id == 26)  then crafter_type, wandstep = "fire", 3
elseif (victim.zone_id == 178 and victim.id == 6) then crafter_type, wandstep = "ice", 3
elseif (victim.zone_id == 100 and victim.id == 56) then crafter_type, wandstep = "acid", 3
elseif (victim.zone_id == 586 and victim.id == 1) then crafter_type, wandstep = "air", 4
elseif (victim.zone_id == 103 and victim.id == 6) then crafter_type, wandstep = "fire", 4
elseif (victim.zone_id == 23 and victim.id == 37)  then crafter_type, wandstep = "ice", 4
elseif (victim.zone_id == 625 and victim.id == 4) then crafter_type, wandstep = "acid", 4
elseif (victim.zone_id == 123 and victim.id == 5) then crafter_type, wandstep = "air", 5
elseif (victim.zone_id == 123 and victim.id == 4) then crafter_type, wandstep = "fire", 5
elseif (victim.zone_id == 550 and victim.id == 13) then crafter_type, wandstep = "ice", 5
elseif (victim.zone_id == 625 and victim.id == 3) then crafter_type, wandstep = "acid", 5
elseif (victim.zone_id == 123 and victim.id == 2) then crafter_type, wandstep = "air", 6
elseif (victim.zone_id == 238 and victim.id == 11) then crafter_type, wandstep = "fire", 6
elseif (victim.zone_id == 238 and victim.id == 2) then crafter_type, wandstep = "ice", 6
elseif (victim.zone_id == 470 and victim.id == 75) then crafter_type, wandstep = "acid", 6
elseif (victim.zone_id == 490 and victim.id == 3) then crafter_type, wandstep = "air", 7
elseif (victim.zone_id == 481 and victim.id == 5) then crafter_type, wandstep = "fire", 7
elseif (victim.zone_id == 533 and victim.id == 16) then crafter_type, wandstep = "ice", 7
elseif (victim.zone_id == 40 and victim.id == 17)  then crafter_type, wandstep = "acid", 7
elseif (victim.zone_id == 85 and victim.id == 15)  then crafter_type, wandstep = "air", 8
elseif (victim.zone_id == 481 and victim.id == 150) then crafter_type, wandstep = "fire", 8
elseif (victim.zone_id == 103 and victim.id == 0) then crafter_type, wandstep = "ice", 8
elseif (victim.zone_id == 480 and victim.id == 29) then crafter_type, wandstep = "acid", 8
elseif (victim.zone_id == 62 and victim.id == 16)  then crafter_type, wandstep = "air", 9
elseif (victim.zone_id == 484 and victim.id == 12) then crafter_type, wandstep = "fire", 9
elseif (victim.zone_id == 100 and victim.id == 12) then crafter_type, wandstep = "ice", 9
elseif (victim.zone_id == 35 and victim.id == 49)  then crafter_type, wandstep = "acid", 9
elseif (victim.zone_id == 185 and victim.id == 81) then crafter_type, wandstep = "air", 10
elseif (victim.zone_id == 52 and victim.id == 30)  then crafter_type, wandstep = "fire", 10
elseif (victim.zone_id == 550 and victim.id == 20) then crafter_type, wandstep = "ice", 10
elseif (victim.zone_id == 163 and victim.id == 15) then crafter_type, wandstep = "acid", 10
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
