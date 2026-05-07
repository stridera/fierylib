-- Trigger: flood_south_destroyed
-- Zone: 390, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39013
--
-- Post-flood state of the south settlement gate (390:187 south exit):
-- gate is gone, just ruins beyond. Fired by the receive trigger after
-- the Lady triggers her cataclysm.

local south = get_room(390, 187):exit("south")
if south then
    south:set_state({has_door = true, closed = true, description = "The ruins of a decimated settlement lay beyond."})
end