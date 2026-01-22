-- Trigger: genasi-sigh
-- Zone: 360, ID: 5
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #36005

-- Converted from DG Script #36005: genasi-sigh
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("sigh")
self:say("I don't really have time for this right now.")
spells.cast(self, "teleport")
-- Should only teleport to 23832-23869, other rooms are outside its range