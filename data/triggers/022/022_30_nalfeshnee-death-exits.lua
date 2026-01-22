-- Trigger: nalfeshnee-death-exits
-- Zone: 22, ID: 30
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2230

-- Converted from DG Script #2230: nalfeshnee-death-exits
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("<cyan>A fierce <blue>wail</><cyan> echoes over the sea!</>")
run_room_trigger(2231)