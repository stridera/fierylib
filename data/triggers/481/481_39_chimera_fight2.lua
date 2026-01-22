-- Trigger: chimera_fight2
-- Zone: 481, ID: 39
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48139

-- Converted from DG Script #48139: chimera_fight2
-- Original: MOB trigger, flags: FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor.name:send("The chimera's lion head snaps at your legs, but you dodge.")
self.room:send_except(actor.name, tostring(actor.name) .. " dodges as the chimera's lion head snaps at them.")