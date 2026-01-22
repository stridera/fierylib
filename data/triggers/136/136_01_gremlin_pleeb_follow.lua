-- Trigger: Gremlin_pleeb_follow
-- Zone: 136, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13601

-- Converted from DG Script #13601: Gremlin_pleeb_follow
-- Original: MOB trigger, flags: GREET, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
-- This trigger was supposed to make the gremlin
-- follow and group with his leader.  I think
-- perhaps this should be a special proc and
-- not a trigger.  These notes are from copying
-- the Mob progs to script format.
self:command("scratch")