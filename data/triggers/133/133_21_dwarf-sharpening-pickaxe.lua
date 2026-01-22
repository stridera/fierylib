-- Trigger: dwarf-sharpening-pickaxe
-- Zone: 133, ID: 21
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #13321

-- Converted from DG Script #13321: dwarf-sharpening-pickaxe
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self.room:send("<b:yellow>Sparks</> fly as a dwarf runs a sharpening-stone down the length of his pickaxe!")