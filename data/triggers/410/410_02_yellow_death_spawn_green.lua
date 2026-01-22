-- Trigger: yellow_death_spawn_green
-- Zone: 410, ID: 2
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41002

-- Converted from DG Script #41002: yellow_death_spawn_green
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- checking if green queen is already loaded
if self:get_mexists("41010") < 1 then
    get_room(410, 30):at(function()
        self.room:spawn_mobile(410, 10)
    end)
    self.room:send(tostring(self.name) .. " moans, 'My green sister will make you sorry!'")
else
    self.room:send(tostring(self.name) .. " moans, 'My green sister will make you sorry!'")
end