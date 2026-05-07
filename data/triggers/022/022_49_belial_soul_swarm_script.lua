-- Trigger: belial_soul_swarm_script
-- Zone: 22, ID: 49
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2249

-- Converted from DG Script #2249: belial_soul_swarm_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- TODO(parity): debug placeholders "To Victim test"/"To Room test" left from
-- conversion; original DG had flavour text for the soul swarm hit on the target.
-- Also: while-loop has no escape if no caster is in room — consider iteration cap.
-- Class compares are case-mismatched (other triggers use "Sorcerer" capitalized);
-- verify actor.class capitalization at runtime.
wait(2)
self.room:send("Belial closes his eyes, raises his hands in the air and shouts, 'Fadre Zarku!'")
wait(1)
local person = 0
while person < 1 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.is_player then
        if victim.class == "sorcerer" or victim.class == "cryomancer" or victim.class == "pyromancer" or victim.class == "priest" or victim.class == "druid" or victim.class == "cleric" then
            victim:send("Soul-wraiths phase out of Belial and lock onto your aura!")
            self.room:send_except(victim, "Soul-wraiths phase out of Belial, locking onto " .. tostring(victim.name) .. "!")
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            person = person + 1
        end
    end
end