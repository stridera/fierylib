-- Trigger: pit-fiend-death-exit
-- Zone: 22, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2205

-- Converted from DG Script #2205: pit-fiend-death-exit
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("<yellow>The ground shakes violently!</>")
run_room_trigger(2206)