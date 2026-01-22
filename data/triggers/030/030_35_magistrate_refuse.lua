-- Trigger: Magistrate refuse
-- Zone: 30, ID: 35
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3035

-- Converted from DG Script #3035: Magistrate refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
-- switch on objet.id
wait(1)
self:say("Thanks!")