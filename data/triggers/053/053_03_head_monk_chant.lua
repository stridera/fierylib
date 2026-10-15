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
do
    local _sw1 = string.lower(tostring(chant or ""))
    if tonumber(_sw1) == 1 then
        self:chant("war cry")
    elseif tonumber(_sw1) == 2 then
        self:chant("battle hymn")
    elseif tonumber(_sw1) == 3 then
        self:chant("peace")
    else
        self:chant("regeneration")
    end
end