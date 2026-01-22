-- Trigger: pippin_death
-- Zone: 43, ID: 46
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #4346

-- Converted from DG Script #4346: pippin_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.room == 4336 then
    get_room(43, 33):at(function()
        run_room_trigger(4398)
    end)
end