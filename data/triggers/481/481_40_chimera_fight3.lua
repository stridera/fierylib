-- Trigger: chimera_fight3
-- Zone: 481, ID: 40
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48140

-- Converted from DG Script #48140: chimera_fight3
-- Original: MOB trigger, flags: FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor.name:send("The chimera's goat head snaps at you, just missing your arm!")
self.room:send_except(actor.name, tostring(actor.name) .. " sweats profusely as the chimera's goat head almost takes off their arm!")