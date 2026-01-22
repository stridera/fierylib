-- Trigger: dargentan_chest_load
-- Zone: 238, ID: 20
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23820

-- Converted from DG Script #23820: dargentan_chest_load
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: donteverletmecatchyouusingthisspeechtrigger
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "donteverletmecatchyouusingthisspeechtrigger")) then
    return true  -- No matching keywords
end
self.room:spawn_object(238, 48)
self.room:send("As the dragon falls, you notice something that wasn't there before...")