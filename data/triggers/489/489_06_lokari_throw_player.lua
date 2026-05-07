-- Trigger: lokari throw player
-- Zone: 489, ID: 6
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Picks two distinct mortal players in the room and slams them into each
-- other. Aborts if a second valid target can't be found.

-- TODO(parity): the converter botched the victim1/victim2 picking loops:
-- block-scoped `local max_tries = 0` rebinds didn't actually break the outer
-- loop, victim1 was scoped inside the loop so unreachable below, and the
-- `_return_value` orphan was undefined. The rewrite below restores intent.
local victim1
for _ = 1, 6 do
    local candidate = room.actors[random(1, #room.actors)]
    if candidate and ((candidate.id < 48900) or (candidate.id > 48999)) and (candidate.level < 100) then
        victim1 = candidate
        break
    end
end
if not victim1 then
    return true
end
local victim2
for _ = 1, 10 do
    local candidate = room.actors[random(1, #room.actors)]
    if candidate and ((candidate.id < 48900) or (candidate.id > 48999)) and (candidate.level < 100) and (victim1.name ~= candidate.name) then
        victim2 = candidate
        break
    end
end
if not victim2 then
    return true
end
local damage1 = 75 + random(1, 50)
local damage2 = 75 + random(1, 50)
if victim1:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage1 = damage1 / 2
end
if victim1:has_effect(Effect.Stone) then
    -- Another 50 damage for target2 if target1 has stoneskin
    damage2 = damage2 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage1 = damage1 / 2
elseif variant == 15 then
    damage1 = damage1 * 2
end
if victim2:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage2 = damage2 / 2
end
if victim2:has_effect(Effect.Stone) then
    -- Another 50 damage for target1 if target2 has stoneskin
    damage1 = damage1 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage2 = damage2 / 2
elseif variant == 15 then
    damage2 = damage2 * 2
end
self.room:send_except(victim1, "Lokari waves a hand at " .. tostring(victim1.name) .. ", picking " .. tostring(victim1.object) .. " up into the air!")
victim1:send("Lokari waves a hand at you, picking you up into the air!")
victim2:teleport(get_room(11, 0))
self.room:send_except(victim1, "Lokari smashes " .. tostring(victim1.name) .. " into " .. tostring(victim2.name) .. " with a flick of his wrist! (<blue>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim1:send("Lokari smashes you into " .. tostring(victim2.name) .. " with a flick of his wrist! (<b:red>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim2:send("Lokari smashes " .. tostring(victim1.name) .. " into you with a flick of his wrist! (<b:red>" .. tostring(damage2) .. "</>) (<blue>" .. tostring(damage1) .. "</>)")
victim2:teleport(get_room(489, 80))
local damage_dealt = victim1:damage(damage1)  -- type: physical
local damage_dealt = victim2:damage(damage2)  -- type: physical