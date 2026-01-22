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
-- switch on random(1, 3)
if random(1, 3) == 1 then
    self.room:send("A few falling leaves burst into flames as they get too close to the burning tree.")
elseif random(1, 3) == 2 then
    self.room:send("The burning tree emits a loud hissing noise that startles a few nearby rodents.")
elseif random(1, 3) == 3 then
    self:emote("curses the Hydra.")
end