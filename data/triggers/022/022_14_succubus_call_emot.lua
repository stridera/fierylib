-- Trigger: Succubus_Call_Emot
-- Zone: 22, ID: 14
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #2214

-- Converted from DG Script #2214: Succubus_Call_Emot
-- Original: MOB trigger, flags: FIGHT, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
wait(2)
run_room_trigger(2213)