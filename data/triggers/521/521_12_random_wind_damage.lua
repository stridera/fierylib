-- Trigger: Random_Wind_Damage
-- Zone: 521, ID: 12
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52112

-- Converted from DG Script #52112: Random_Wind_Damage
-- Original: WORLD trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
if actor.id == -1 then
    wait(1)
    local rndm = room.actors[random(1, #room.actors)]
    rndm:damage(65)  -- type: cold
    if damage_dealt == 0 then
        rndm:send("A strong gust blows in from the north, cooling you.")
        self.room:send_except(rndm, "A strong gust blows in from the north, which seems to soothe " .. tostring(rndm.name) .. ".")
    else
        rndm:send("A strong gust blows in from the north, giving you an awful chill. (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(rndm, "A strong gust blows in from the north, which seems to chill " .. tostring(rndm.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
    end
end