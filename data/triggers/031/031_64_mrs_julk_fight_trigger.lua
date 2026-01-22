-- Trigger: mrs julk fight trigger
-- Zone: 31, ID: 64
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #3164

-- Converted from DG Script #3164: mrs julk fight trigger
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
local target = self.is_fighting
local tank = target.is_fighting
if target then
    if tank ~= "self" then
        if mode > 3 then
            skills.execute(self, "backstab", self.fighting)
        else
            skills.execute(self, "kick", self.fighting)
        end
    elseif tank == "self" then
        if mode > 6 then
            skills.execute(self, "kick", self.fighting)
        end
    end
    wait(3)
end