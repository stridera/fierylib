-- Trigger: Obelisk (Food)
-- Zone: 0, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10

-- Converted from DG Script #10: Obelisk (Food)
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: All Hail Uklor
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "all") or string.find(string.lower(speech), "hail") or string.find(string.lower(speech), "uklor")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    self.room:send("</>&9<blue>The ancient </><magenta>obelisk</>&9<blue> hums with pleasure.</>")
    self.room:send("A gust of </><white></>divine</><b:yellow> energy</> sweeps through the room, leaving a loaf of </><yellow>bread</> in its wake.")
    self.room:spawn_object(147, 11)
end