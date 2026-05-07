-- Trigger: undefined
-- Zone: 625, ID: 49
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #62549

-- Converted from DG Script #62549: undefined
-- Original: MOB trigger, flags: DEATH, probability: 0%
--
-- TODO(parity): The legacy script had no body and ran at 0%
-- probability — effectively a placeholder. Left as a no-op.

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
return true
