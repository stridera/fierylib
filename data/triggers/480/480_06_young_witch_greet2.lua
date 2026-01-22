-- Trigger: young_witch_greet2
-- Zone: 480, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48006

-- Converted from DG Script #48006: young_witch_greet2
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    actor.name:send("The young witch drops her book and hisses at you.")
end