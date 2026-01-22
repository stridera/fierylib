-- Trigger: luchiaans_death
-- Zone: 510, ID: 25
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #51025

-- Converted from DG Script #51025: luchiaans_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("Before his death, Luchiaans silently chants his final incantation.")
self.room:send("You briefly see a flash of light, and you hear a loud BOOOM!")
self.room:teleport_all(get_room(510, 0))
get_room(510, 0):at(function()
    self.room:find_actor("all"):command("look")
end)