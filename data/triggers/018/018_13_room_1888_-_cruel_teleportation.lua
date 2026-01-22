-- Trigger: Room 1888 - Cruel teleportation
-- Zone: 18, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1813

-- Converted from DG Script #1813: Room 1888 - Cruel teleportation
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: submit
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "submit")) then
    return true  -- No matching keywords
end
actor.name:command("forget all")
actor.name:send("You feel drained and disoriented.")
self.room:send_except(actor.name, tostring(actor.name) .. " fades from existence and disappears.")
local rm = random(1, 10)
-- switch on rm
if rm == 1 then
    actor.name:teleport(get_room(520, 70))
elseif rm == 2 then
    actor.name:teleport(get_room(480, 80))
elseif rm == 3 then
    actor.name:teleport(get_room(118, 34))
elseif rm == 4 then
    actor.name:teleport(get_room(118, 35))
elseif rm == 5 then
    local dest = 43144 + random(1, 13)
    actor.name:teleport(get_room(vnum_to_zone(dest), vnum_to_local(dest)))
elseif rm == 6 then
    actor.name:teleport(get_room(101, 0))
elseif rm == 7 then
    actor.name:teleport(get_room(551, 5))
elseif rm == 8 then
    actor.name:teleport(get_room(325, 89))
elseif rm == 9 then
    actor.name:teleport(get_room(127, 1))
    actor.name:teleport(get_room(520, 86))
end
self:command("force " .. tostring(actor) .. " look")