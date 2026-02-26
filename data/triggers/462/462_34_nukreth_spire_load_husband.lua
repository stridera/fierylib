-- Trigger: Nukreth Spire load husband
-- Zone: 462, ID: 34
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #46234

-- Converted from DG Script #46234: Nukreth Spire load husband
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
if world.count_mobiles(462, 6) == 0 and world.count_mobiles(462, 7) == 0 and world.count_mobiles(462, 8) == 0 and world.count_mobiles(462, 20) > 0 then
    if world.count_mobiles(462, 25) == 0 then
        self.room:spawn_mobile(462, 25)
    end
end