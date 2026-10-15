-- Trigger: mccabe's fight trig
-- Zone: 481, ID: 152
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
    do
        local _sw1 = string.lower(tostring(random(1, 3) or ""))
        local _run1 = false
        repeat
            if _run1 or tonumber(_sw1) == 1 then
                _run1 = true
                spells.cast(self, "fireball", actor)
            end
            if _run1 or tonumber(_sw1) == 2 then
                _run1 = true
                spells.cast(self, "acid burst", actor)
            end
            do  -- default
                _run1 = true
                spells.cast(self, "positive field", actor)
            end
        until true
    end
end
wait(2)