-- Trigger: Fairy tickles people
-- Zone: 615, ID: 2
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #61502

-- Converted from DG Script #61502: Fairy tickles people
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
wait(4)
local val = random(1, 3)
-- switch on val
if val == 1 then
    local ch = room.actors[random(1, #room.actors)]
    self:command("tickle " .. tostring(ch.name))
else
    self:command("tickle gnome")
end