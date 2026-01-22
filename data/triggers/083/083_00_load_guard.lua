-- Trigger: Load_Guard
-- Zone: 83, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #8300

-- Converted from DG Script #8300: Load_Guard
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.alignment < -349 then
    wait(2)
    self.room:send("A giant guard pops out from behind the coffin.")
    get_room(84, 23):at(function()
        find_player("frakatiguard"):teleport(get_room(83, 63))
    end)
end