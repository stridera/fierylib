-- Trigger: Beast_10
-- Zone: 17, ID: 94
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1794

-- Converted from DG Script #1794: Beast_10
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end

-- One-shot per beast lifetime: only trigger the rat swarm once.
if globals.done10 then
    return true
end
globals.done10 = true

self.room:send(tostring(self) .. " howls out in pain, writhing to and fro, its eyes glowing in rage and fear!")
self.room:send("RUN FOR YOUR LIFE!")

-- Spawn 47 rats (mob 480:24) and have each attack the actor.
-- TODO: original DG #1794 likely used a wait/loop; verify count is intentional.
for _ = 1, 47 do
    self.room:spawn_mobile(480, 24)
    local rat = self.room:find_actor("rat")
    if rat then
        rat:command("kill " .. tostring(actor.name))
    end
end
