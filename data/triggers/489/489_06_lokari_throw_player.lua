-- Trigger: lokari throw player
-- Zone: 489, ID: 6
-- Type: WORLD, Flags: GLOBAL
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #48906

-- Converted from DG Script #48906: lokari throw player
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local max_tries = 6
while max_tries > 0 do
    local victim1 = room.actors[random(1, #room.actors)]
    if ((victim1.id < 48900) or (victim1.id > 48999)) and (victim1.level < 100) then
        local max_tries = 0
    end
    local max_tries = max_tries - 1
end
if max_tries ~= -1 then
    return _return_value
end
local max_tries = 10
while max_tries > 0 do
    local victim2 = room.actors[random(1, #room.actors)]
    if ((victim2.id < 48900) or (victim2.id > 48999)) and (victim2.level < 100) and (victim1.name ~= victim2.name) then
        local max_tries = 0
    end
    local max_tries = max_tries - 1
end
if max_tries ~= -1 then
    return _return_value
end
local damage1 = 75 + random(1, 50)
local damage2 = 75 + random(1, 50)
if victim1:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    local damage1 = damage1 / 2
end
if victim1:has_effect(Effect.Stone) then
    -- Another 50 damage for target2 if target1 has stoneskin
    local damage2 = damage2 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    local damage1 = damage1 / 2
elseif variant == 15 then
    local damage1 = damage1 * 2
end
if victim2:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    local damage2 = damage2 / 2
end
if victim2:has_effect(Effect.Stone) then
    -- Another 50 damage for target1 if target2 has stoneskin
    local damage1 = damage1 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    local damage2 = damage2 / 2
elseif variant == 15 then
    local damage2 = damage2 * 2
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