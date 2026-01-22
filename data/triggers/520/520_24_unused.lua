-- Trigger: UNUSED
-- Zone: 520, ID: 24
-- Type: WORLD, Flags: COMMAND, RESET, PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #52024

-- Converted from DG Script #52024: UNUSED
-- Original: WORLD trigger, flags: COMMAND, RESET, PREENTRY, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local damage = random(1, 2000)
while people.52086 > 0 do
    local damage_dealt = room.actors[random(1, #room.actors)]:damage(damage)  -- type: physical
end