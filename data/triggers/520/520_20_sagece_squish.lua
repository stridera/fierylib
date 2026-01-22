-- Trigger: sagece squish
-- Zone: 520, ID: 20
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52020

-- Converted from DG Script #52020: sagece squish
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("<b:cyan>Sagece of Raymif beats her monstrous wings, launching herself into the air!</>")
wait(5)
local victim = 0
local count = 0
while victim == 0 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id == 52012 then
        local victim = 0
    end
    local count = count + 1
    if count > 10 then
        self.room:send("<yellow>Sagece of Raymif slowly returns to the floor, rattling the hall.</>")
        return _return_value
    end
end
victim:damage(5000)  -- type: crush
self.room:send_except(victim, "<cyan>Sagece of Raymif swoops down, dropping her bulk onto " .. tostring(victim.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
victim:send("<cyan>Sagece of Raymif swoops down, dropping her massive bulk on <b:red>YOU</><cyan>!</> (<red>" .. tostring(damage_dealt) .. "</>)")