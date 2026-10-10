-- Trigger: Fields_of_fire_damage
-- Zone: 22, ID: 3
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2203

-- Converted from DG Script #2203: Fields_of_fire_damage
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
end