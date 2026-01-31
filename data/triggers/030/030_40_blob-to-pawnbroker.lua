-- Trigger: blob-to-pawnbroker
-- Zone: 30, ID: 40
-- Type: MOB, Flags: RANDOM, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3040

-- Converted from DG Script #3040: blob-to-pawnbroker
-- Original: MOB trigger, flags: RANDOM, SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: drop off the junk
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "drop") or string.find(string.lower(speech), "off") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "junk")) then
    return true  -- No matching keywords
end
self:teleport(get_room(61, 72))
self:destroy_item("all.key")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(61, 72))
self:command("remove all")
self:command("drop all")
self.room:find_actor("pawnbroker"):command("get all")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(60, 34))
local randmielrm = random(1, 18)
self:teleport(get_room(30, randmielrm + 51))