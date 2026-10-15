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
do
    local _sw1 = string.lower(tostring(val or ""))
    local _run1 = false
    repeat
        if _run1 or tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
            _run1 = true
            self:say("Man, Rydack is a slave driver.")
        end
        if _run1 or tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
            _run1 = true
            self:emote("starts using OLC.")
            break
        end
        if _run1 or tonumber(_sw1) == 5 or tonumber(_sw1) == 6 then
            _run1 = true
            self:emote("looks at his watch.")
            break
        end
        do  -- default
            _run1 = true
            self:emote("looks around to see if anyone is watching.")
        end
    until true
end