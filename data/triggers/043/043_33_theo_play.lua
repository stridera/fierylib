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
local held = self:get_worn(17)  -- Hold slot
if held and held.zone_id == 43 and held.local_id == 11 then
    self:emote("pets a duck lovingly.")
    wait(4)
    self:command("pur")
else
    self:command("whine")
    wait(4)
    self:say("I want my duck!!")
end