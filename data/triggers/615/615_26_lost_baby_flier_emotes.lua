-- Trigger: Lost baby flier emotes
-- Zone: 615, ID: 26
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61526

-- Converted from DG Script #61526: Lost baby flier emotes
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
local val = random(1, 7)
if val == 1 then
    self:emote("tries to hop behind a tree trunk.")
elseif val == 2 then
    self:emote("squeaks in terror!")
elseif val == 3 then
    self:emote("flaps its little wings furiously.")
elseif val == 4 then
    self:emote("peers up at you with frightened eyes.")
elseif val == 5 then
    self:emote("tries desperately to crawl under a little pile of leaves.")
elseif val == 6 then
    self:emote("pounces on an unsuspecting insect.")
    wait(3)
    self:emote("crunches noisily for a few seconds, then emits a tiny *burp*.")
end