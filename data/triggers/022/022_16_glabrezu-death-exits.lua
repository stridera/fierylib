-- Trigger: glabrezu-death-exits
-- Zone: 22, ID: 16
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2216

-- Converted from DG Script #2216: glabrezu-death-exits
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("<b:red>The fires begin to <yellow>burn <white>white-hot!</>")
run_room_trigger(2217)