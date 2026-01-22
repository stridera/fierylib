-- Trigger: infidel2_fight
-- Zone: 480, ID: 24
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48024

-- Converted from DG Script #48024: infidel2_fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local fight = time.stamp
globals.fight = globals.fight or true
if random(1, 10) < 4 then
    self.room:send("The body of the infidel shifts slightly but remains renewed.")
end