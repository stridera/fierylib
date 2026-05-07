-- Trigger: sagece squish
-- Zone: 520, ID: 20
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52020

-- Converted from DG Script #52020: sagece squish
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Sagece's "squish" attack: she launches and drops onto a random non-self
-- victim for 5000 crush damage. Up to 10 reroll attempts to avoid landing
-- on herself (520:12); if no valid target, she lands gracefully.
self.room:send("<b:cyan>Sagece of Raymif beats her monstrous wings, launching herself into the air!</>")
wait(5)
local victim = nil
for attempt = 1, 10 do
    local pick = room.actors[random(1, #room.actors)]
    if pick and not (pick.zone_id == 520 and pick.local_id == 12) then
        victim = pick
        break
    end
end
if not victim then
    self.room:send("<yellow>Sagece of Raymif slowly returns to the floor, rattling the hall.</>")
    return true
end
local damage_dealt = victim:damage(5000)  -- crush
self.room:send_except(victim, "<cyan>Sagece of Raymif swoops down, dropping her bulk onto " .. tostring(victim.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
victim:send("<cyan>Sagece of Raymif swoops down, dropping her massive bulk on <b:red>YOU</><cyan>!</> (<red>" .. tostring(damage_dealt) .. "</>)")