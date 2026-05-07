-- Trigger: green_death_spawn_blue
-- Zone: 410, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41003
-- On green queen's death, spawn the blue queen (410:11) in room 410:39
-- if she is not already loaded. Either way, broadcast her dying lament.

self.room:send(tostring(self.name) .. " mutters, 'Mother always said my blue sister would look after me...'")
if world.count_mobiles(410, 11) < 1 then
    get_room(410, 39):at(function()
        self.room:spawn_mobile(410, 11)
    end)
end