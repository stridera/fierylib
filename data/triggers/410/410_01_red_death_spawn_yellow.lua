-- Trigger: red_death_spawn_yellow
-- Zone: 410, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41001
-- On red queen's death, spawn the yellow queen (410:9) in room 410:21
-- if she is not already loaded. Either way, broadcast her dying threat.

self.room:send(tostring(self.name) .. " screams, 'My yellow sister shall avenge my death!'")
if world.count_mobiles(410, 9) < 1 then
    get_room(410, 21):at(function()
        self.room:spawn_mobile(410, 9)
    end)
end