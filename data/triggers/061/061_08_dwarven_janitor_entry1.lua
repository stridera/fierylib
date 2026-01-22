-- Trigger: dwarven_janitor_entry1
-- Zone: 61, ID: 8
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #6108

-- Converted from DG Script #6108: dwarven_janitor_entry1
-- Original: MOB trigger, flags: ENTRY, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:command("sigh")
self:say("So much litter, this job is unending.")
self:command("grumble")