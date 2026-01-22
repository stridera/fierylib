-- Trigger: Mystwatch_cycle_semantics_1
-- Zone: 160, ID: 15
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #16015

-- Converted from DG Script #16015: Mystwatch_cycle_semantics_1
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 14%

-- 14% chance to trigger
if not percent_chance(14) then
    return true
end
self.room:send("A silhouette moves across the shadows.")
self:command("hide")