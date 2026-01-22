-- Trigger: armor of gaia destroy self remove
-- Zone: 10, ID: 0
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #1000

-- Converted from DG Script #1000: armor of gaia destroy self remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
wait(2)
self.room:send(tostring(self.name) .. " crumbles to dust and blows away.")
world.destroy(self)