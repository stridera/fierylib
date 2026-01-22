-- Trigger: green_death_spawn_blue
-- Zone: 410, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41003

-- Converted from DG Script #41003: green_death_spawn_blue
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- checking if blue queen is already loaded
if self:get_mexists("41011") < 1 then
    get_room(410, 39):at(function()
        self.room:spawn_mobile(410, 11)
    end)
    self.room:send(tostring(self.name) .. " mutters, 'Mother always said my blue sister would look after me...'")
else
    self.room:send(tostring(self.name) .. " mutters, 'Mother always said my blue sister would look after me...'")
end