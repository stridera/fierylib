-- Trigger: Sapsucker harassing tree
-- Zone: 615, ID: 7
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61507

-- Converted from DG Script #61507: Sapsucker harassing tree
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local val = random(1, 20)
-- switch on val
if val == 1 then
    self:emote("pecks loudly on the tree trunk.")
elseif val == 2 then
    self:emote("eyes you suspiciously.")
elseif val == 3 then
    self:emote("hops up the trunk, looking for a good place to make a hole.")
elseif val == 4 then
    self:emote("flutters over to an adjacent tree.")
end