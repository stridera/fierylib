-- Trigger: belial_soul_swarm_script
-- Zone: 22, ID: 49
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2249

-- Converted from DG Script #2249: belial_soul_swarm_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("Start of 2249")
wait(2)
self.room:send("Belial closes his eyes, raises his hands in the air and shouts, 'Fadre Zarku!'")
wait(1)
local person = 0
while person < 1 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id == -1 then
        if victim.class == "sorcerer" or victim.class == "cryomancer" or victim.class == "pyromancer" or victim.class == "priest" or victim.class == "druid" or victim.class == "cleric" then
            victim:send("To Victim test")
            self.room:send_except(victim, "To Room test")
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill %victim.name%")
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill %victim.name%")
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill %victim.name%")
            local person = person + 1
        end
    end
end