-- Trigger: new trigger
-- Zone: 14, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #1403

-- Converted from DG Script #1403: new trigger
-- Original: MOB trigger, flags: GREET, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end
wait(1)
if string.find(arg, "truth") or string.find(arg, "eye") or string.find(arg, "eyes") then
end  -- auto-close block