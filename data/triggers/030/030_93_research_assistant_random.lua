-- Trigger: research_assistant_random
-- Zone: 30, ID: 93
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #3093

-- Converted from DG Script #3093: research_assistant_random
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("sigh")
self:say("She was suppose to be here already.")
wait(20)
self:say("She must be lost.")
wait(20)
self:say("Bigby's not going to be happy about this.")