-- Trigger: Gothra_Old_Man_greet
-- Zone: 161, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #16105
--
-- Flavor greet: the old man eyes the newcomer and grumbles about adventurers.
wait(1)
self:command("eye")
actor:send("An old man rubs his chin and ponders about you.")
actor:send("An old man says 'hrmff probably some adventurer looking for trouble.'")