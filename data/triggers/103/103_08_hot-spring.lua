-- Trigger: hot-spring
-- Zone: 103, ID: 8
-- Type: WORLD, Flags: RANDOM, SPEECH, PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #10308

-- Converted from DG Script #10308: hot-spring
-- Original: WORLD trigger, flags: RANDOM, SPEECH, PREENTRY, probability: 100%

-- Speech keywords: .
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), ".")) then
    return true  -- No matching keywords
end
if not actor then
    local actor = room.actors[random(1, #room.actors)]
end
if not actor then
    return _return_value
end
local fireproof = not actor:has_effect(Effect.HeatResistance)
if actor.id == -1 then
    if actor.class == "Pyromancer" then
    elseif fireproof then
    else
        local damage = random(1, 10) + random(1, 10)
        self.room:send_except(actor, tostring(actor.name) .. " starts to look a bit woozy from the extreme heat.")
        actor:send("The water is too hot for you....")
        local damage_dealt = actor:damage(damage)  -- type: physical
    end
end