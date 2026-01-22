-- Trigger: Nukreth Spire captive death
-- Zone: 462, ID: 29
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46229

-- Converted from DG Script #46229: Nukreth Spire captive death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.id == 46220 and world.count_mobiles("46225") then
    self.room:send("A limping slave tries to save his wife but is killed by the attack!")
    world.destroy(self.room:find_actor("limping-slave"))
elseif self.id == 46225 and world.count_mobiles("46220") then
    self.room:send("A Soltan peasant tries to save her husband but is killed by the attack!")
    world.destroy(self.room:find_actor("soltan-captive"))
end
get_room(462, 78):at(function()
    run_room_trigger(46236)
end)