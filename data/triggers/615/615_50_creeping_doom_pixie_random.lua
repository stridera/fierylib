-- Trigger: creeping_doom_pixie_random
-- Zone: 615, ID: 50
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61550

-- Converted from DG Script #61550: creeping_doom_pixie_random
-- Original: MOB trigger, flags: RANDOM, probability: 12%

-- 12% chance to trigger
if not percent_chance(12) then
    return true
end
-- switch on random(1, 4)
if random(1, 4) == 1 then
    self:emote("grumbles about mortals shattering the natural order.")
elseif random(1, 4) == 2 then
    self:say("I swear I will find a vessel for nature's vengeance!")
elseif random(1, 4) == 3 then
    self:say("Someday we'll take revenge on the mortal races...")
elseif random(1, 4) == 4 then
else
    self:emote("makes a mystic gesture and surrounds herself with a swirling swarm of insects!")
end