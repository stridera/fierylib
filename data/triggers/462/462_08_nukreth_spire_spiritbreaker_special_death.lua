-- Trigger: Nukreth Spire spiritbreaker special death
-- Zone: 462, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46208

-- Converted from DG Script #46208: Nukreth Spire spiritbreaker special death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.room == 46278 then
    if world.count_mobiles("46220") then
        run_room_trigger(46209)
    elseif world.count_mobiles("46221") then
        run_room_trigger(46210)
    elseif world.count_mobiles("46222") then
        run_room_trigger(46211)
    elseif world.count_mobiles("46223") then
        run_room_trigger(46212)
    end
end