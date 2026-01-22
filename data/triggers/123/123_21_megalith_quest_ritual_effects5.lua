-- Trigger: megalith_quest_ritual_effects5
-- Zone: 123, ID: 21
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12321

-- Converted from DG Script #12321: megalith_quest_ritual_effects5
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
zone.echo(123, "<b:blue>The rift <yellow>in the sky begins<blue> to churn and swirl.</>_")
zone.echo(123, "<b:blue>Millions of <yellow>tiny stars <blue>and <cyan>alien moons <blue>twinkle in the depths of the vortex.</>")
wait(4)
self.room:send(tostring(mobiles.template(123, 1).name) .. " chants:")
self.room:send("'Ringing now the bell in three")
self.room:send("Hear our prayer.'")
wait(3)
self.room:send(tostring(mobiles.template(123, 1).name) .. " says, 'Chant it with us!'_")
self.room:send("'<b:cyan>We summon and stir thee</>!'")