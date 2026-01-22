-- Trigger: Shadow pixie's rambling
-- Zone: 615, ID: 34
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #61534

-- Converted from DG Script #61534: Shadow pixie's rambling
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
-- switch on random(1, 7)
if random(1, 7) == 1 then
    self:say("You dare to intrude?")
elseif random(1, 7) == 2 then
    self:say("Niaxxa will hear about this...")
elseif random(1, 7) == 3 then
    self:say("These shadows still hold dark shades, flatlander!")
elseif random(1, 7) == 4 then
    self:say("You are clever to come so far, but the queen still awaits.")
elseif random(1, 7) == 5 then
    self:say("This one is not like the others.")
end