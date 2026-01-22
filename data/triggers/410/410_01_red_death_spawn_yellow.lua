-- Trigger: red_death_spawn_yellow
-- Zone: 410, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41001

-- Converted from DG Script #41001: red_death_spawn_yellow
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- checking if yellow queen is already loaded
if self:get_mexists("41009") < 1 then
    -- load the yellow queen'
    get_room(410, 21):at(function()
        self.room:spawn_mobile(410, 9)
    end)
    self.room:send(tostring(self.name) .. " screams, 'My yellow sister shall avenge my death!'")
else
    self.room:send(tostring(self.name) .. " screams, 'My yellow sister shall avenge my death!'")
end