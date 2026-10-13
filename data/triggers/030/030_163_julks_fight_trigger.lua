-- Trigger: julks fight trigger
-- Zone: 30, ID: 163
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #3163

-- Converted from DG Script #3163: julks fight trigger
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- FIGHT trigger: `self` is the mob being hit, `actor` is whoever just attacked it.
-- The legacy script read %self.fighting% (the mob's opponent) and %target.fighting%
-- (whom that opponent fights, "tank"). In mud-script `is_fighting` is only a
-- boolean and there is no opponent accessor, so the attacker stands in for the
-- opponent (it just swung at us, so it is fighting us: tank == self) and the
-- skills run with no target, which uses the mob's current opponent.
local mode = random(1, 10)
local target = actor
if target and target.is_fighting then
    if mode > 6 then
        skills.execute(self, "kick", nil)
    else
        skills.execute(self, "bash", nil)
    end
    wait(3)
end
