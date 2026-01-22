-- Trigger: dog_greet2
-- Zone: 61, ID: 12
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #6112

-- Converted from DG Script #6112: dog_greet2
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor:send(tostring(self.name) .. " wanders up to you and sniffs your leg.")
actor:send(tostring(self.name) .. " whimpers and moves away from you with its tail between its legs.")