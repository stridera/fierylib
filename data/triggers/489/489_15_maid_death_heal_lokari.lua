-- Trigger: maid death heal lokari
-- Zone: 489, ID: 15
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48915

-- Converted from DG Script #48915: maid death heal lokari
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local actor = room.actors[random(1, #room.actors)]
if actor and world.count_mobiles("48901") then
    self.room:send("Lokari absorbs the maid's spirit as it leaves her body.")
    get_room(489, 15):at(function()
        self.room:find_actor("lokari"):heal(2000)
    end)
end
wait(1)
if actor and (world.count_mobiles("48923") == 0) then
    local stop_casting = 1
    globals.stop_casting = globals.stop_casting or true
end