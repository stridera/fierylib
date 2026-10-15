-- Trigger: grig_play_random
-- Zone: 615, ID: 44
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61544

-- Converted from DG Script #61544: grig_play_random
-- Original: MOB trigger, flags: RANDOM, probability: 8%

-- 8% chance to trigger
if not percent_chance(8) then
    return true
end
local play = random(1, 3)
-- switch on play
do
    local _sw1 = string.lower(tostring(play or ""))
    if tonumber(_sw1) == 1 then
        self:emote("fiddles a jaunty tune!")
    elseif tonumber(_sw1) == 2 then
        self:emote("dances a merry jig!")
    elseif tonumber(_sw1) == 3 then
        self:emote("plays a soulful, wistful number of ages long past.")
    else
        self:emote("tunes his fiddle.")
    end
end