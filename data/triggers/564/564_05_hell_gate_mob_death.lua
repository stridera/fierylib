-- Trigger: hell_gate_mob_death
-- Zone: 564, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #56405
--
-- Hell-gate stage 3: when a player wearing the ritual dagger (564, 7)
-- kills one of seven specific "child" mob types, drop the matching
-- blood vial (564, 0..6) once per kind. 35% trigger probability.

-- 35% chance to trigger
if not percent_chance(35) then
    return true
end
if actor:get_quest_stage("hell_gate") ~= 3 then
    return true
end
if not actor:has_equipped(564, 7) then
    return true
end

-- Map killer mob (legacy vnum) -> blood vial local id within zone 564.
local blood
local vnum = self.zone_id * 100 + self.id
if vnum == 12010 then
    blood = 0
elseif vnum == 30054 then
    blood = 1
elseif vnum == 32408 then
    blood = 2
elseif vnum == 48125 then
    blood = 3
elseif vnum == 48126 then
    blood = 4
elseif vnum == 51003 or vnum == 51018 or vnum == 51023 then
    blood = 5
elseif vnum == 55238 then
    blood = 6
else
    return true
end

local key = "blood" .. tostring(blood)
if not actor:get_quest_var("hell_gate:" .. key) then
    actor:set_quest_var("hell_gate", key, 1)
    self.room:spawn_object(564, blood)
end
