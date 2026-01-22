-- Trigger: Beast Dirt Trig
-- Zone: 17, ID: 92
-- Type: MOB, Flags: GREET, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #1792

-- Converted from DG Script #1792: Beast Dirt Trig
-- Original: MOB trigger, flags: GREET, FIGHT, probability: 100%
self.room:send_except(actor, "he <red>Enraged Beast</> kicks up a <yellow>claw full of dirt</> into " .. tostring(actor.name) .. "'s face &9<blue>blinding</> him!")
-- Orphaned text: The &1%Enraged Beast%&0 kicks up a &3claw full of dirt&0 into your face &9&bblinding&0 you!