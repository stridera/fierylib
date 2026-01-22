-- Trigger: fv_Gwion_entry
-- Zone: 534, ID: 7
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #53407

-- Converted from DG Script #53407: fv_Gwion_entry
-- Original: MOB trigger, flags: ENTRY, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
wait(1)
self:command("peer")
wait(2)
self:command("sigh")
self:say("anyone fancy a game of dice?")