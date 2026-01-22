-- Trigger: Smugg_guard_rand2
-- Zone: 363, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #36303

-- Converted from DG Script #36303: Smugg_guard_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("looks around furtively.")
self:emote("hurriedly munches on a stolen donut.")
self:command("burp")
self:command("blush")