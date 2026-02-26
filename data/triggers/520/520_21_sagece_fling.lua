-- Trigger: sagece fling
-- Zone: 520, ID: 21
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52021

-- Converted from DG Script #52021: sagece fling
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local victim = room.actors[random(1, #room.actors)]
if victim.id ~= 52012 then
    local damage = 75 + random(1, 40)
    self.room:send_except(victim, "<green>Sagece of Raymif sweeps with her enormous tail, throwing " .. tostring(victim.name) .. " from the area!</> (<blue>" .. tostring(damage) .. "</>)")
    victim:send("<green>Sagece of Raymif sweeps with her enormous tail, knocking you out of the area!</> (<b:red>" .. tostring(damage) .. "</>)")
    local room = 52082 + random(1, 5)
    if room == 52086 then
        local room = 52083
    end
    victim:teleport(get_room(vnum_to_zone(room), vnum_to_local(room)))
    -- victim looks around
end