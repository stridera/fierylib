-- Trigger: object_cast_insanity
-- Zone: 1, ID: 50
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #150

-- Converted from DG Script #150: object_cast_insanity
-- Original: OBJECT trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
local worn = self.worn_by
if not worn then
    return true
end
if worn.id == -1 then
    worn:send(self.shortdesc .. " whispers words of madness to you!")
    spells.cast(self, "insanity", worn, self.level)
end