-- Trigger: fv_Gwion_greet
-- Zone: 534, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53406

-- Converted from DG Script #53406: fv_Gwion_greet
-- Original: MOB trigger, flags: GREET, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if actor.id == -1 then
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Hello Traveler, my name is Gwion'")
    self:command("bow")
else
    wait(1)
    self:command("poke " .. tostring(actor.name))
    self:say("fancy a game of dice?")
    actor:emote("mutters an excuse and looks around for an exit.")
end