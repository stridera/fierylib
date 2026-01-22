-- Trigger: fight_kick
-- Zone: 590, ID: 24
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #59024

-- Converted from DG Script #59024: fight_kick
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local rdm = random(1, 10)
-- switch on rdm
if rdm == 1 or rdm == 2 or rdm == 3 then
    wait(3)
    skills.execute(self, "kick", self.fighting)
end