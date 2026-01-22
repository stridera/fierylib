-- Trigger: pasty_greet1
-- Zone: 481, ID: 27
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48127

-- Converted from DG Script #48127: pasty_greet1
-- Original: MOB trigger, flags: GREET, probability: 80%

-- 80% chance to trigger
if not percent_chance(80) then
    return true
end
wait(2)
if actor.id == -1 then
    self:emote("mutters to himself.")
    self:say("Where has he gone?")
    wait(2)
    self:command("peer " .. tostring(actor.name))
    self:say("Could you help me find my friend?")
end