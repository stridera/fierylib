-- Trigger: Fireplace_burns
-- Zone: 16, ID: 89
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1689

-- Converted from DG Script #1689: Fireplace_burns
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self.actor_count > 0 then
    local damage = random(1, 6) + 6
    local victim = room.actors[random(1, #room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            victim:send("The roaring fire flares up, but you are well protected from its blaze.")
            self.room:send_except(victim, "A flare within the fire engulfs " .. tostring(victim.name) .. ", but " .. tostring(actor.name) .. " is well protected against the inferno.")
        else
            victim:send("The roaring fire flares up, burning you! (<red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " cries out in pain as " .. tostring(victim.name) .. " is burned by the fire! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end