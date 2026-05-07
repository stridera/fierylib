-- Trigger: lokari hitprcnt 50
-- Zone: 489, ID: 4
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #48904

-- Converted from DG Script #48904: lokari hitprcnt 50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 50%

-- 50% chance to trigger; on the first such fire, prime the cleric-healing
-- mode (trigger 13) and bump the global init counter so subsequent half-HP
-- procs don't re-prime the same mode.
if not percent_chance(50) then
    return true
end
if globals.init == 1 then
    run_room_trigger(489, 13)
    globals.init = 2
end