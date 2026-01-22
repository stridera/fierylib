-- Trigger: Head Monk chant
-- Zone: 53, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #5303

-- Converted from DG Script #5303: Head Monk chant
-- Original: MOB trigger, flags: RANDOM, probability: 100%
local chant = random(1, 4)
-- switch on chant
if chant == 1 then
    self:chant("war cry")
elseif chant == 2 then
    self:chant("battle hymn")
elseif chant == 3 then
    self:chant("peace")
elseif chant == 4 then
else
    self:chant("regeneration")
end