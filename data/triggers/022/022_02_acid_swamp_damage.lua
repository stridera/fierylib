-- Trigger: Acid_swamp_damage
-- Zone: 22, ID: 2
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2202

-- Converted from DG Script #2202: Acid_swamp_damage
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
end