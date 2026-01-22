-- Trigger: box_crumble
-- Zone: 43, ID: 47
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4347

-- Converted from DG Script #4347: box_crumble
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
wait(60)
self.room:send("The wreckage of the fire box burns itself out, leaving behind only ash.")
world.destroy(self)