-- Trigger: luchiaans_death
-- Zone: 510, ID: 25
-- Type: MOB, Flags: DEATH
--
-- Original DG Script: #51025
-- On Luchiaans' death, his final incantation banishes everyone in
-- the room to room (510, 0). The original DG also force-looked every
-- arrived actor; the engine handles room descriptions on entry, so
-- the explicit force-look is omitted.
self.room:send("Before his death, Luchiaans silently chants his final incantation.")
self.room:send("You briefly see a flash of light, and you hear a loud BOOOM!")
self.room:teleport_all(get_room(510, 0))
