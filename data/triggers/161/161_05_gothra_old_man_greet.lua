-- Trigger: Gothra_Old_Man_greet
-- Zone: 161, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #16105

-- Converted from DG Script #16105: Gothra_Old_Man_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
self:command("eye")
actor:send("An old man rubs his chin and ponders about you.")
actor:send("An old man says 'hrmff probably some adventurer looking for trouble.'")