-- Trigger: Bard AI
-- Zone: 1, ID: 15
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #115

-- Converted from DG Script #115: Bard AI
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if not self:get_has_spell("inspiration") then
    self:perform("inspiration", self, self.level)
end