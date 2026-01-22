-- Trigger: haggard_dwarf_greet
-- Zone: 16, ID: 87
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #1687

-- Converted from DG Script #1687: haggard_dwarf_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(5)
self:emote("rushes toward you, yelling in a frenzy!")
wait(15)
self:emote("trips over his own feet and lands flat on his face!")
wait(20)
self:emote("quickly scrambles back to a corner of the cell.")
wait(15)
self:say("If you're here to kill me, then do it already!")
wait(1)
self:say("If not, then why are you here?  Are you a friend to us dwarves?")
wait(2)
self:command("whine")