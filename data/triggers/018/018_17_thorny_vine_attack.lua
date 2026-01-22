-- Trigger: thorny_vine_attack
-- Zone: 18, ID: 17
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #1817

-- Converted from DG Script #1817: thorny_vine_attack
-- Original: MOB trigger, flags: GREET, probability: 14%

-- 14% chance to trigger
if not percent_chance(14) then
    return true
end
if actor.id == -1 and actor.level < 100 then
    actor.name:send("You step on a thorny vine, which attempts to wrap around your leg!")
    self.room:send_except(actor.name, tostring(actor.name) .. " steps on a thorny vine, which flails wildly in response.")
    combat.engage(self, actor.name)
end