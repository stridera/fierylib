-- Trigger: Nukreth Spire spiritbreaker special death
-- Zone: 462, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46208

-- Converted from DG Script #46208: Nukreth Spire spiritbreaker special death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.room == 46278 then
    if world.count_mobiles(462, 20) > 0 then
        run_room_trigger(462, 9)
    elseif world.count_mobiles(462, 21) > 0 then
        run_room_trigger(462, 10)
    elseif world.count_mobiles(462, 22) > 0 then
        run_room_trigger(462, 11)
    elseif world.count_mobiles(462, 23) > 0 then
        run_room_trigger(462, 12)
    end
end