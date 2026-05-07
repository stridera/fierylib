-- Trigger: Beast_50
-- Zone: 17, ID: 96
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1796

-- Converted from DG Script #1796: Beast_50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end

-- One-shot per beast lifetime.
if globals.done50 then
    return true
end
globals.done50 = true

self.room:send(tostring(self.name) .. " writhes in pain, slamming its enormous claws on the ground!")
self.room:send("-     -    -   -  - -----BANG----- -  -   -    -     -")

-- Spawn 25 ripples (mob 28:1) and have each attack the actor.
-- TODO: original DG #1796 likely used a wait/loop; verify count is intentional.
for _ = 1, 25 do
    self.room:spawn_mobile(28, 1)
    local ripples = self.room:find_actor("ripples")
    if ripples then
        ripples:command("kill " .. tostring(actor.name))
    end
end
