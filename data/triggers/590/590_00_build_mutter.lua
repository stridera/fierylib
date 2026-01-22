-- Trigger: build_mutter
-- Zone: 590, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #59000

-- Converted from DG Script #59000: build_mutter
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
local val = random(1, 10)
-- switch on val
if val == 1 or val == 2 then
    self:say("Man, Rydack is a slave driver.")
elseif val == 3 or val == 4 then
    self:emote("starts using OLC.")
elseif val == 5 or val == 6 then
    self:emote("looks at his watch.")
else
    self:emote("looks around to see if anyone is watching.")
end