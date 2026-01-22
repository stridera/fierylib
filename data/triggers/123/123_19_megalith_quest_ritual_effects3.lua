-- Trigger: megalith_quest_ritual_effects3
-- Zone: 123, ID: 19
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12319

-- Converted from DG Script #12319: megalith_quest_ritual_effects3
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
zone.echo(123, "<b:white>Beams of <yellow>light <white>shoot up from the menhirs meet and unite above the altar.</>_")
zone.echo(123, "<b:blue>The fabric of the sky <yellow>rips <blue>open like a flame burning through paper.</>")
wait(4)
self.room:send(tostring(mobiles.template(123, 1).name) .. " chants:")
self.room:send("'Ringing now the bell in three")
self.room:send("Hear our prayer.'")
wait(3)
self.room:send(tostring(mobiles.template(123, 1).name) .. " says, 'Chant it with us!'_")
self.room:send("'<b:cyan>We summon and stir thee</>!'")