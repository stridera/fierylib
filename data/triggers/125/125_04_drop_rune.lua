-- Trigger: Drop_rune
-- Zone: 125, ID: 4
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #12504

-- Converted from DG Script #12504: Drop_rune
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 12504 then
    wait(1)
    world.destroy(object)
    wait(5)
    self.room:send("The runestone flares green as it falls into place.")
    wait(1)
    self.room:send("As the stone settles, a field of green energy spreads across the circle of stones.")
    self.room:spawn_object(125, 5)
    wait(1)
end