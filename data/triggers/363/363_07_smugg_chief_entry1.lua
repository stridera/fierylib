-- Trigger: Smugg_chief_entry1
-- Zone: 363, ID: 7
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #36307

-- Converted from DG Script #36307: Smugg_chief_entry1
-- Original: MOB trigger, flags: ENTRY, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:say("There'd better not be any pinching of donuts going on round, here.")
self:command("peer 2.smuggler")
self:say("It will come out of your wages if there is.")
self:command("glare")