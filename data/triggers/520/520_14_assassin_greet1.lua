-- Trigger: assassin_greet1
-- Zone: 520, ID: 14
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52014

-- Converted from DG Script #52014: assassin_greet1
-- Original: MOB trigger, flags: GREET, probability: 80%

-- 80% chance to trigger
if not percent_chance(80) then
    return true
end
if actor.level < 100 then
    self:emote("whispers, 'Trespassers!'")
    skills.execute(self, "backstab", actor.name)
else
    self:command("bow " .. tostring(actor.name))
    self:say("Welcome, Diety.")
end