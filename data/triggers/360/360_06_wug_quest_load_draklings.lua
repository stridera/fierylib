-- Trigger: wug_quest_load_draklings
-- Zone: 360, ID: 6
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #36006

-- Converted from DG Script #36006: wug_quest_load_draklings
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send(tostring(mobiles.template(360, 4).name) .. " lets slip a crystalline amulet which shatters on impact!")
self.room:send(tostring(mobiles.template(360, 4).name) .. " groans, 'They will now be free of our prison...'")
wait(1)
self.room:send("All the seethers begin chittering!")
wait(1)
self.room:send("Off in the distance you hear the ROAR of a dragon of some kind!")
self.room:send("It seems to be coming from the farmlands to the south of the temple.")