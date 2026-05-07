-- Trigger: Load_Guard
-- Zone: 83, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- When a sufficiently evil player enters this room, summon the frakati guard
-- from his post in room (83, 123) into room (83, 63) so he can confront the
-- intruder.
--
-- Original DG Script: #8300
if actor.alignment < -349 then
    wait(2)
    self.room:send("A giant guard pops out from behind the coffin.")
    get_room(83, 123):at(function()
        local guard = self.room:find_actor("frakatiguard")
        if guard then
            guard:teleport(get_room(83, 63))
        end
    end)
end