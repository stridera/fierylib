-- Trigger: sorcha_greet
-- Zone: 533, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53301

-- Converted from DG Script #53301: sorcha_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    self:command("gasp")
    self:say("You dare to approach the altar of the mighty Tri-Aszp?!")
    self:emote("prays silently for a few seconds to her overlord.")
end