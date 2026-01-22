-- Trigger: belial_spawn_demon_belial
-- Zone: 22, ID: 43
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #2243

-- Converted from DG Script #2243: belial_spawn_demon_belial
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 100%
-- Spawn Demon Belial on 5% HP
local belial_queue = 3
local victim = room.actors[random(1, #room.actors)]
self.room:spawn_mobile(22, 21)
self.room:send("Belial falls to one knee, his chest heaving in exhaustion from battle.")
wait(3)
self.room:send("Belial says in common, 'Fools!  You have yet to witness the true power of the Nines!'")
self.room:send("Belial contorts momentarily as wings and shadow tentacles sprout from his back.")
wait(3)
self.room:send("Belial slowly rises up, his demonic form dwarfing you in size.")
self.room:send("Belial throws back his head and roars with ferocity, causing your soul to quake.")
wait(1)
self:command("force destruction kill " .. tostring(victim.name))
world.destroy(self)