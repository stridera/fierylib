-- Trigger: nalfeshnee-load-mirror
-- Zone: 22, ID: 31
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2231

-- Converted from DG Script #2231: nalfeshnee-load-mirror
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<cyan>Out of nowhere, a <blue>mirror</><cyan> appears!</>")
self.room:spawn_object(237, 72)