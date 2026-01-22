-- Trigger: lokari hitprcnt 50
-- Zone: 489, ID: 4
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #48904

-- Converted from DG Script #48904: lokari hitprcnt 50
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if init == 1 then
    run_room_trigger(48913)
    local init = 2
    globals.init = globals.init or true
end