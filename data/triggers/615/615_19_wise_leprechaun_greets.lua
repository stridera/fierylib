-- Trigger: Wise leprechaun greets
-- Zone: 615, ID: 19
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #61519

-- Converted from DG Script #61519: Wise leprechaun greets
-- Original: MOB trigger, flags: GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
if actor.id == -1 then
    wait(6)
    if actor.gender == "female" then
        self:say("Well hello there, little lassie!")
    else
        self:say("Well hello there, whippersnapper!")
    end
    wait(5)
    self:command("bow " .. tostring(actor.name))
end