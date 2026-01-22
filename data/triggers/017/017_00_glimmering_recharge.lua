-- Trigger: glimmering_recharge
-- Zone: 17, ID: 0
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #1700

-- Converted from DG Script #1700: glimmering_recharge
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 1700 then
    wait(1)
    self.room:send("Just as the ring hits the ground, the chest opens as if by magic.")
    wait(1)
    self.room:send("A bright light eminates from chest, focusing on the ring.")
    wait(1)
    self.room:send("The light subsides and the chest closes without help.")
    world.destroy(self.room:find_actor("glimmering"))
    self.room:spawn_object(17, 0)
end