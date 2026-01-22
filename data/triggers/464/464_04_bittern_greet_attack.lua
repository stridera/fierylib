-- Trigger: bittern_greet_attack
-- Zone: 464, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #46404

-- Converted from DG Script #46404: bittern_greet_attack
-- Original: MOB trigger, flags: GREET, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
-- attack them players!
if actor.id == -1 then
    if actor.level < 100 then
        wait(1)
        self.room:send_except(actor, tostring(self.name) .. " flies into a rage!")
        actor:send(tostring(self.name) .. " flies into a rage and attacks you!")
        combat.engage(self, actor.name)
    end
end