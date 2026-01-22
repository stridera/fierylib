-- Trigger: chimera_fight1
-- Zone: 481, ID: 38
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48138

-- Converted from DG Script #48138: chimera_fight1
-- Original: MOB trigger, flags: FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor.name:send("YOWZER, the dragon head's fiery breath singed the top of your head!")
self.room:send_except(actor.name, "The dragon head misses " .. tostring(actor.name) .. " with its fiery breath, but their hair smokes slightly!")