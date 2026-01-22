-- Trigger: apprentice_greet1
-- Zone: 178, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #17806

-- Converted from DG Script #17806: apprentice_greet1
-- Original: MOB trigger, flags: GREET, probability: 75%

-- 75% chance to trigger
if not percent_chance(75) then
    return true
end
if actor.id == -1 then
    self:command("sigh")
    self:emote("mumbles to himself about completing his training.")
    self:say("If you need help, just ask.")
else
    self:command("flee")
end