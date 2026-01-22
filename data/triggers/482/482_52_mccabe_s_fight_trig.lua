-- Trigger: mccabe's fight trig
-- Zone: 482, ID: 52
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48252

-- Converted from DG Script #48252: mccabe's fight trig
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local line = random(1, 10)
if line == 1 then
    self:say("You are a fool!")
elseif line == 2 then
    self:say("Do you really think you can match my power?!")
elseif line == 3 then
    self:say("It would have been wise to try to learn from me.")
    self:say("...But now you must die!")
end
local heat = "!HEAT"
if string.find(actor.eff_flags, "heat") or actor:get_eff_flagged("sanct") then
    if random(1, 2) == 2 then
        self:say("Your magic is powerful, but not powerful enough to stop this force!")
    end
    spells.cast(self, "meteorswarm", actor)
elseif actor:get_eff_flagged("stone") then
    spells.cast(self, "dispel mag", actor)
elseif actor:get_eff_flagged("coldshield") then
    spells.cast(self, "melt", actor)
elseif actor:get_eff_flagged("fireshield") then
    spells.cast(self, "immolate", actor)
else
    -- switch on random(1, 3)
    if random(1, 3) == 1 then
        spells.cast(self, "fireball", actor)
    elseif random(1, 3) == 2 then
        spells.cast(self, "acid burst", actor)
    else
        spells.cast(self, "positive field", actor)
    end
end
wait(2)