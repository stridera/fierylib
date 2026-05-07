-- Trigger: dying_tree_rand1
-- Zone: 520, ID: 18
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52018

-- Converted from DG Script #52018: dying_tree_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- Pick one ambient line.
local roll = random(1, 3)
if roll == 1 then
    self.room:send("A few falling leaves burst into flames as they get too close to the burning tree.")
elseif roll == 2 then
    self.room:send("The burning tree emits a loud hissing noise that startles a few nearby rodents.")
else
    self:emote("curses the Hydra.")
end