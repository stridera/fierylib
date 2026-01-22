-- Trigger: druid_moonwell_clue
-- Zone: 30, ID: 95
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #3095

-- Converted from DG Script #3095: druid_moonwell_clue
-- Original: MOB trigger, flags: RANDOM, probability: 8%

-- 8% chance to trigger
if not percent_chance(8) then
    return true
end
self:command("sigh")
wait(15)
self:say("Such a shame she had to be punished.")