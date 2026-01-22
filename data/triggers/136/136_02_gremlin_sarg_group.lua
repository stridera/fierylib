-- Trigger: gremlin_sarg_group
-- Zone: 136, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13602

-- Converted from DG Script #13602: gremlin_sarg_group
-- Original: MOB trigger, flags: GREET, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
-- 
-- This was a prog that was to make this mobile
-- group his followers after they followed and
-- consented to him.  It was messed up and didn't
-- work.  Perhaps this should be compiled as a
-- spec proc.  These notes exist for clarity of
-- zone development in the future.
-- 
self:command("growl")