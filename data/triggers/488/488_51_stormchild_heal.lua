-- Trigger: stormchild heal
-- Zone: 488, ID: 51
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48851

-- Converted from DG Script #48851: stormchild heal
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("<blue>The Stormchild's eyes open wide as a massive lightning bolt strikes her in the chest!</>")
self.room:find_actor("stormchild"):heal(1000)