-- Trigger: Beast_25
-- Zone: 17, ID: 95
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1795

-- Converted from DG Script #1795: Beast_25
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end

-- One-shot per beast lifetime.
if globals.done25 then
    return true
end
globals.done25 = true

self.room:send("The ground all around begins to rustle with life...")

-- Spawn 30 maudlin panthers (mob 430:1) and have each attack the actor.
-- TODO: original DG #1795 likely used a wait/loop; verify count is intentional.
for _ = 1, 30 do
    self.room:spawn_mobile(430, 1)
    local panther = self.room:find_actor("maudlin-panther")
    if panther then
        panther:command("kill " .. tostring(actor.name))
    end
end
