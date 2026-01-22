-- Trigger: velocity fight
-- Zone: 489, ID: 21
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48921

-- Converted from DG Script #48921: velocity fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if not (self:get_worn("wield")) then
    self:command("get indigo-blade")
    self:command("wield indigo-blade")
end
if not (self:get_worn("wield2")) then
    self:command("get indigo-blade")
    self:command("wield indigo-blade")
end