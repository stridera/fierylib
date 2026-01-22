-- Trigger: Smugg_chief_entry2
-- Zone: 363, ID: 8
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #36308

-- Converted from DG Script #36308: Smugg_chief_entry2
-- Original: MOB trigger, flags: ENTRY, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("shouts, 'Ok, lets get those crates moving people.'")
self:command("whap 2.smuggler")
self:emote("shouts, 'Move it, move it, MOVE IT!'")