-- Trigger: rope_ladder
-- Zone: 490, ID: 10
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #49010

-- Converted from DG Script #49010: rope_ladder
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 49041 then
    wait(1)
    self.room:send("The ladder unrolls and forms a rigid structure down the cliff.")
    get_room(491, 49):exit("d"):set_state({hidden = false})
    get_room(490, 28):exit("u"):set_state({hidden = false})
    world.destroy(self.room:find_actor("rope-ladder"))
end