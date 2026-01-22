-- Trigger: Knight_Bash
-- Zone: 521, ID: 8
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #52108

-- Converted from DG Script #52108: Knight_Bash
-- Original: MOB trigger, flags: FIGHT, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("remove sword")
self:command("wear shield")
skills.execute(self, "bash", self.fighting)
self:command("stand")
wait(2)
self:command("remove shield")
self:command("wield sword")