-- Trigger: Ordinary leprechaun greet
-- Zone: 615, ID: 27
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #61527

-- Converted from DG Script #61527: Ordinary leprechaun greet
-- Original: MOB trigger, flags: GREET, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
if actor.id == -1 and actor.level < 50 then
    wait(8)
    self:say("Oh no you can't have it!  It's mine!")
    wait(3)
    self:command("glare " .. tostring(actor.name))
end