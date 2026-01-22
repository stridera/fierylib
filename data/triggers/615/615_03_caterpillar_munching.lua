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
if val == 1 then
    self:emote("rears up and twists around wildly, seeking a new grip.")
elseif val == 2 then
    self:emote("crawls slowly up a stem.")
elseif val == 3 then
    self:emote("crawls slowly down a stem.")
else
    self:emote("munches on a milkweed leaf.")
end