-- Trigger: seer_rand1
-- Zone: 490, ID: 21
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #49021

-- Converted from DG Script #49021: seer_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:emote("moans and sways as she prepares to utter one of her cryptic sayings.")
local rndm = random(1, 100)
if rndm < 50 then
    self:say("The ship was carrying French wine beyond the Spanish sea.")
else
    if rndm < 75 then
        self:say("The ship finder?  Crazily sounds like there is about a thousand.")
    else
        self:say("Always wear sunscreen.")
    end
end