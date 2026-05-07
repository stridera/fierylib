-- Trigger: Beast Dirt Trig
-- Zone: 17, ID: 92
-- Type: MOB, Flags: GREET, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #1792

-- Converted from DG Script #1792: Beast Dirt Trig
-- Original: MOB trigger, flags: GREET, FIGHT, probability: 100%
actor:send("The <red>Enraged Beast</> kicks up a <yellow>claw full of dirt</> into your face <blue>blinding</> you!")
self.room:send_except(actor, "The <red>Enraged Beast</> kicks up a <yellow>claw full of dirt</> into " .. tostring(actor.name) .. "'s face <blue>blinding</> " .. tostring(actor.object) .. "!")