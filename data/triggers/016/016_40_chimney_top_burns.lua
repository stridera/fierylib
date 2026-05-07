-- Trigger: Chimney_top_burns
-- Zone: 16, ID: 40
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1640

-- Converted from DG Script #1640: Chimney_top_burns
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self.actor_count > 0 then
    local damage = 1
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            victim:send("The burning smoke blows into your eyes, but you are well protected from its damage.")
            self.room:send_except(victim, "Burning smoke billows around " .. tostring(victim.name) .. ", deflected by " .. tostring(victim.possessive) .. " magic.")
        else
            victim:send("Burning smoke blows straight into your eyes!  It burns! (<red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " cries out in pain as " .. tostring(victim.name) .. " is burned by the smoke in " .. tostring(victim.possessive) .. " eyes! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end