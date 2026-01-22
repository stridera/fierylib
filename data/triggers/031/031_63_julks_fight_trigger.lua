-- Trigger: julks fight trigger
-- Zone: 31, ID: 63
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #3163

-- Converted from DG Script #3163: julks fight trigger
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
local target = self.is_fighting
local tank = target.is_fighting
if target then
    if tank ~= "self" then
        if mode > 5 then
            skills.execute(self, "backstab", self.fighting)
        elseif mode > 2 then
            skills.execute(self, "kick", self.fighting)
        else
            self:command("corner")
        end
    elseif tank == "self" then
        if mode > 6 then
            skills.execute(self, "kick", self.fighting)
        else
            skills.execute(self, "bash", self.fighting)
        end
    end
    wait(3)
end