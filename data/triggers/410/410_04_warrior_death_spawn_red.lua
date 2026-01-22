-- Trigger: warrior_death_spawn_red
-- Zone: 410, ID: 4
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41004

-- Converted from DG Script #41004: warrior_death_spawn_red
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- check if red queen already loaded
if self:get_mexists("41008") < 1 then
    -- load red queen
    get_room(410, 15):at(function()
        self.room:spawn_mobile(410, 8)
    end)
    self.room:send(tostring(self.name) .. " shouts, 'I'm sorry, my Queen!'")
else
    self.room:send(tostring(self.name) .. " shouts, 'I'm sorry, my Queen!'")
end