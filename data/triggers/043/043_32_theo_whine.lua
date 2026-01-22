-- Trigger: theo_whine
-- Zone: 43, ID: 32
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4332

-- Converted from DG Script #4332: theo_whine
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
if self:get_worn("18") == 4311 then
    self:emote("pets a duck lovingly.")
    wait(4)
    self:emote("quacks like a duck!  QUACK!")
else
    self:emote("plays around with a brilliantly colored piece of fabric.")
    wait(3)
    self:say("Whee!")
    wait(4)
    self:say("I wish Otto were here to play King with me too...")
end