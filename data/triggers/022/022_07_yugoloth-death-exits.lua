-- Trigger: yugoloth-death-exits
-- Zone: 22, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2207

-- Converted from DG Script #2207: yugoloth-death-exits
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("<green>A horrid squelching can be heard as the swamp begins to drain!</>")
run_room_trigger(2208)