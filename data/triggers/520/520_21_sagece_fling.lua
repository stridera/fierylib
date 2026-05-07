-- Trigger: sagece fling
-- Zone: 520, ID: 21
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52021

-- Converted from DG Script #52021: sagece fling
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Sagece's tail "fling" attack: random non-self victim takes 75-115 damage
-- and is thrown to a random satellite room (520:82, 83, 84, 85, 87). Room
-- 520:86 is excluded (re-route to 520:83).
local victim = room.actors[random(1, #room.actors)]
if victim and not (victim.zone_id == 520 and victim.local_id == 12) then
    local damage = 75 + random(1, 40)
    victim:damage(damage)
    self.room:send_except(victim, "<green>Sagece of Raymif sweeps with her enormous tail, throwing " .. tostring(victim.name) .. " from the area!</> (<blue>" .. tostring(damage) .. "</>)")
    victim:send("<green>Sagece of Raymif sweeps with her enormous tail, knocking you out of the area!</> (<b:red>" .. tostring(damage) .. "</>)")
    local dest_id = 82 + random(0, 4)
    if dest_id == 86 then
        dest_id = 83
    end
    victim:teleport(520, dest_id)
    victim:command("look")
end