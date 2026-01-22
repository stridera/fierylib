-- Trigger: theo_play
-- Zone: 43, ID: 33
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4333

-- Converted from DG Script #4333: theo_play
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if self:get_worn("18") == 4311 then
    self:emote("pets a duck lovingly.")
    wait(4)
    self:command("pur")
else
    self:command("whine")
    wait(4)
    self:say("I want my duck!!")
end