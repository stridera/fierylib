-- Trigger: Caterpillar munching
-- Zone: 615, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61503

-- Converted from DG Script #61503: Caterpillar munching
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
local val = random(1, 10)
-- switch on val
do
    local _sw1 = string.lower(tostring(val or ""))
    if tonumber(_sw1) == 1 then
        self:emote("rears up and twists around wildly, seeking a new grip.")
    elseif tonumber(_sw1) == 2 then
        self:emote("crawls slowly up a stem.")
    elseif tonumber(_sw1) == 3 then
        self:emote("crawls slowly down a stem.")
    else
        self:emote("munches on a milkweed leaf.")
    end
end