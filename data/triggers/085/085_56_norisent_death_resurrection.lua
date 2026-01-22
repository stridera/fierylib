-- Trigger: Norisent_death_resurrection
-- Zone: 85, ID: 56
-- Type: MOB, Flags: GLOBAL, DEATH
-- Status: CLEAN
--
-- Original DG Script: #8556

-- Converted from DG Script #8556: Norisent_death_resurrection
-- Original: MOB trigger, flags: GLOBAL, DEATH, probability: 100%
if complete then
    self.room:spawn_object(85, 51)
    self.room:send("<b:green>A small book slips from " .. tostring(self.name) .. "'s robes.</>")
end