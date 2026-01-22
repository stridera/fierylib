-- Trigger: Succubus_Call_Emot
-- Zone: 22, ID: 12
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #2212

-- Converted from DG Script #2212: Succubus_Call_Emot
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
wait(2)
run_room_trigger(2211)