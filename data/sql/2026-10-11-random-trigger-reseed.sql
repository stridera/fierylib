-- Re-seed the four RANDOM triggers 22/2, 22/3, 22/4, 125/22 on DBs still holding the pre-e42fd48 bodies (dev, dated 2026-05-17). Content is the same as 2026-10-10-random-trigger-fixes.sql, but guarded by the md5 of the old body so Muditor edits are left alone. Prod already holds the new bodies (no-op).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/022/022_02_acid_swamp_damage.lua
  (22, 2, $trig$-- Converted from DG Script #2202: Acid_swamp_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
-- self is the room in a WORLD trigger; self.room resolves to it.
local room = self.room
if room == nil then
    return true
end
local count = room.actor_count
if count > 3 then
    count = 3
end
while count > 0 do
    -- Everyone may have left (or died) during the wait: re-read the occupants each round
    local actors = room.actors
    if #actors == 0 then
        break
    end
    local victim = actors[random(1, #actors)]
    -- legacy vnum 2213: mob 13 in this zone is immune
    if not (victim.zone_id == 22 and victim.id == 13) then
        local damage = 50 + random(1, 30)
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            local damage_dealt = victim:damage(damage)  -- type: poison
            victim:send("You accidentally inhale some noxious gases!  Oops! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, tostring(victim.name) .. " suddenly chokes, coughing on the acrid swamp gases. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        elseif which == 2 then
            local damage_dealt = victim:damage(damage)  -- type: acid
            victim:send("A large bubble pops in the waters, spewing acid on you! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "A large bubble pops in the waters, spewing burning acid on " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
        end
    end
    count = count - 1
    wait(3)
end$trig$, '3e0c0894e0e6f07f6bb937ed06a90834'),
  -- data/triggers/022/022_03_fields_of_fire_damage.lua
  (22, 3, $trig$-- Converted from DG Script #2203: Fields_of_fire_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- self is the room in a WORLD trigger; self.room resolves to it.
local room = self.room
if room == nil then
    return true
end
local count = room.actor_count
if count > 3 then
    count = 3
end
while count > 0 do
    -- Everyone may have left (or died) during the wait: re-read the occupants each round
    local actors = room.actors
    if #actors == 0 then
        break
    end
    local victim = actors[random(1, #actors)]
    -- legacy vnum 2214: mob 14 in this zone is immune
    if not (victim.zone_id == 22 and victim.id == 14) then
        local damage = 40 + random(1, 20)
        local which = random(1, 3)
        damage = damage * 2
        -- switch on which
        if which == 1 then
            local damage_dealt = victim:damage(damage)  -- type: fire
            victim:send("Scorching <red>flames</> burst out of a nearby crack, scalding your skin! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "White-hot flames explode out of a crack in the ground right next to " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        elseif which == 2 then
            local damage_dealt = victim:damage(damage)  -- type: fire
            victim:send("Bubbling, hot lava roils out of the ground onto your feet! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "Burning lava bubbles out of the ground onto " .. tostring(victim.name) .. "'s feet! Ouch! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        elseif which == 3 then
            local damage_dealt = victim:damage(damage)  -- type: fire
            victim:send("The sharp leaves of a lava bush cut at your legs! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, tostring(victim.name) .. " yelps as a lava bush's sharp leaves slice into " .. tostring(victim.possessive) .. " legs. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
            damage = math.floor(damage * 1.5)
            local damage_dealt = victim:damage(damage)  -- type: fire
            victim:send("Some of your hair spontaneously catches fire, burning your scalp! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "A caustic odor fills the air as " .. tostring(victim.name) .. "'s hair suddenly bursts into flame. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        end
    end
    count = count - 1
    wait(3)
end$trig$, '912cb026c43633b09a6d279cd61b1dfa'),
  -- data/triggers/022/022_04_dark_ice_sea_damage.lua
  (22, 4, $trig$-- Converted from DG Script #2204: Dark_ice_sea_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- self is the room in a WORLD trigger; self.room resolves to it.
local room = self.room
if room == nil then
    return true
end
local count = room.actor_count
if count > 3 then
    count = 3
end
while count > 0 do
    -- Everyone may have left (or died) during the wait: re-read the occupants each round
    local actors = room.actors
    if #actors == 0 then
        break
    end
    local victim = actors[random(1, #actors)]
    -- legacy vnum 2215: mob 15 in this zone is immune
    if not (victim.zone_id == 22 and victim.id == 15) then
        local damage = 20 + random(1, 15)
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- Less damage for flying people
            if not (victim:has_effect(Effect.Flying)) then
                damage = damage * 3
            end
            local damage_dealt = victim:damage(damage)  -- type: slash
            victim:send("A sharp-edged iceberg suddenly comes rushing out of the water and into you! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "A twisted iceberg suddely rushes out of the water, striking " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
            -- More damage for people with stoneskin
            if not (victim:has_effect(Effect.Stone)) then
                damage = damage * 3
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("Ice begins to form around your stony skin, dragging you downwards! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                room:send_except(victim, "Frost starts forming all over the skin of " .. tostring(victim.name) .. ", freezing " .. tostring(victim.possessive) .. " joints! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            else
                damage = damage * 2
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("The dark waters around you begin to chill your bones. (<b:red>" .. tostring(damage_dealt) .. "</>)")
                room:send_except(victim, tostring(victim.name) .. " grows a little blue and begins to shiver. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    count = count - 1
    wait(3)
end$trig$, '2ef47b2f78096fa5604ed90f5483c41b'),
  -- data/triggers/125/125_22_firebreather.lua
  (125, 22, $trig$-- Converted from DG Script #12522: FireBreather
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
-- Note: self is an Object; self.room is the room it sits in (or its carrier's room)
local room = self.room
if room ~= nil and #room.actors > 0 then
    room:send("The dragon starts to rumble.")
    wait(2)
    room:send("The dragon blasts a gout of <b:red>flame</>, incinerating the room.")
    -- Re-read the occupants: they may have left during the wait
    local actors = room.actors
    if #actors == 0 then
        return true
    end
    local prsn = actors[random(1, #actors)]
    local dmg = random(1, 100) + 50
    local damage_dealt = prsn:damage(dmg)
    if damage_dealt == 0 then
        room:send_except(prsn, "A fiery blast is absorbed by " .. tostring(prsn.name) .. ".")
        prsn:send("Your body is hit by a <red>fiery</> blast! Luckily you absorb the blast.")
    else
        room:send_except(prsn, tostring(prsn.name) .. " is caught in the fiery blast! (<red>" .. tostring(damage_dealt) .. "</>)")
        prsn:send("You are caught in the <red>fiery</> blast! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end$trig$, 'f7892c0d9075ee4b65f28055c73f0826')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
