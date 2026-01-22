-- Trigger: Statue_trigger
-- Zone: 125, ID: 8
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12508

-- Converted from DG Script #12508: Statue_trigger
-- Original: WORLD trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self.room:send("Blue crackles of lightning seem to crawl up the statues leg!")
wait(2)
self.room:send("Before your very eyes, the top of the leg glows blue, and starts to liquefy.")
wait(2)
self.room:send("The leg resolidifies, with more of the thigh than before intact!")