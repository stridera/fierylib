-- Trigger: VULCERA_gets_ring
-- Zone: 481, ID: 12
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #48112

-- Converted from DG Script #48112: VULCERA_gets_ring
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 48127 then
    wait(2)
    world.destroy(self.room:find_actor("ivory-ring"))
    find_player("vulcera"):teleport(get_room(482, 9))
    get_room(482, 9):at(function()
        self.room:find_actor("ai"):say("vulcera-load-ring")
    end)
end