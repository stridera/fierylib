-- Trigger: Aviar_troll_greet
-- Zone: 464, ID: 2
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #46402

-- Converted from DG Script #46402: Aviar_troll_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- Simple greet trig
if actor.is_player then
    if actor.level > 99 then
        wait(1)
        actor:send(tostring(self.name) .. " cringes in terror as you appear!")
    else
        wait(1)
        actor:send(tostring(self.name) .. " sniffs at the air and wrinkles its nose.  Its stomach growls ominously.")
        actor:send(tostring(self.name) .. " whispers to you, 'Is you tasty good-eats?'")
        if percent_chance(35) then
            wait(1)
            self.room:send_except(actor, tostring(self.name) .. " roars in terrible hunger and lunges for " .. tostring(actor.name) .. "!!")
            actor:send(tostring(self.name) .. " roars in terrible hunger and lunges for you!")
            combat.engage(actor)
        end
    end
end