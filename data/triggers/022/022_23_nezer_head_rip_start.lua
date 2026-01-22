-- Trigger: Nezer_head_rip_start
-- Zone: 22, ID: 23
-- Type: MOB, Flags: FIGHT, HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #2223

-- Converted from DG Script #2223: Nezer_head_rip_start
-- Original: MOB trigger, flags: FIGHT, HIT_PERCENT, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
run_room_trigger(2222)