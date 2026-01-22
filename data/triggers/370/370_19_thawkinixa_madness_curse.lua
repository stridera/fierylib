-- Trigger: thawkinixa_madness_curse
-- Zone: 370, ID: 19
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #37019

-- Converted from DG Script #37019: thawkinixa_madness_curse
-- Original: OBJECT trigger, flags: RANDOM, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local worn = self.worn_by
local carried = self.carried_by
if not worn and not carried then
    return _return_value
elseif worn.id == -1 then
    worn:send("Desire for thawkinixa overwhelms your thoughts!")
    spells.cast(self, "confusion", worn, self.level)
elseif carried.id == -1 then
    carried:send("Desire for thawkinixa overwhelms your thoughts!")
    spells.cast(self, "confusion", carried, self.level)
end