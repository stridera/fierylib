-- Trigger: belial_fissure_script
-- Zone: 22, ID: 48
-- Type: WORLD, Flags: GLOBAL
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #2248

-- Converted from DG Script #2248: belial_fissure_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- trigger info here
local count = self.actor_count
if count > 3 then
    local count = 3
end
while count > 0 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id == -1 then
        local damage = 225 + random(1, 75)
        local which = random(1, 3)
        local fireproof = not victim:has_effect(Effect.HeatResistance)
        -- switch on which
        if not (fireproof) then
            if which == 1 then
                local damage = damage * 2
            end
            victim:send("Scorching flames burst out of a nearby fissure, scalding your skin! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "White-hot flames explode out of a fissure in the ground next to " .. tostring(victim.name) .. "! (<blue>" .. tostring(damage) .. "</>)")
            if not (fireproof) then
            elseif which == 2 then
                local damage = damage * 2
            end
            victim:send("Bubbling, hot lava roils out of the ground onto your feet! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "Burning lava bubbles out of the ground onto " .. tostring(victim.name) .. "'s feet! Ouch! (<blue>" .. tostring(damage) .. "</>)")
        else
            if not (fireproof) then
                local damage = damage * 3
            end
            victim:send("A torrent of molten lava consumes you, engulging you in flame! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "A torrent of molten lava consumes " .. tostring(victim.name) .. ", engulfing " .. tostring(victim.name) .. " in flame. (<blue>" .. tostring(damage) .. "</>)")
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    local count = count - 1
    wait(2)
end