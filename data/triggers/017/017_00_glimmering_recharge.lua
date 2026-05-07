-- Trigger: glimmering_recharge
-- Zone: 17, ID: 0
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #1700

-- Converted from DG Script #1700: glimmering_recharge
-- Original: WORLD trigger, flags: DROP, probability: 100%
-- Fires when an object is dropped in this room. Filter to the
-- glimmering ring (zone 17, local id 0) and recharge it.
if object.zone_id == 17 and object.local_id == 0 then
    wait(1)
    self:send("Just as the ring hits the ground, the chest opens as if by magic.")
    wait(1)
    self:send("A bright light eminates from chest, focusing on the ring.")
    wait(1)
    self:send("The light subsides and the chest closes without help.")
    world.destroy(object)
    self:spawn_object(17, 0)
end