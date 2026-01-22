-- Trigger: Unused trigger?
-- Zone: 125, ID: 10
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #12510

-- Converted from DG Script #12510: Unused trigger?
-- Original: OBJECT trigger, flags: WEAR, probability: 63%

-- 63% chance to trigger
if not percent_chance(63) then
    return true
end
actor:award_exp(-100000)
actor.name:send("As you grab the fist, you feel a slight jolt, and feel your life force being drained.")