-- Trigger: Beast_75
-- Zone: 17, ID: 97
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1797

-- Converted from DG Script #1797: Beast_75
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 75%

-- 75% chance to trigger
if not percent_chance(75) then
    return true
end

-- One-shot per beast lifetime.
if globals.done75 then
    return true
end
globals.done75 = true

self.room:send(tostring(self) .. " screeches as its face contorts in pain!")
self.room:send("The despicable beasts of the realm come to its assistance!")

-- Spawn 11 demons (mob 160:9) and have each attack the actor.
-- TODO: original DG #1797 likely used a wait/loop; verify count is intentional.
for _ = 1, 11 do
    self.room:spawn_mobile(160, 9)
    local demon = self.room:find_actor("demon")
    if demon then
        demon:command("kill " .. tostring(actor.name))
    end
end
