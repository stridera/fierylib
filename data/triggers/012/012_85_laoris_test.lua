-- Trigger: laoris test
-- Zone: 12, ID: 85
-- Type: WORLD, Flags: GLOBAL, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1285

-- Converted from DG Script #1285: laoris test
-- Original: WORLD trigger, flags: GLOBAL, SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: angel
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "angel")) then
    return true  -- No matching keywords
end
self.room:send("AFF: " .. tostring(actor.aff_flags))
self.room:send("FLAGS: " .. tostring(actor.flags))
self.room:send("DET-MAGIC?: " .. tostring(actor:has_effect(Effect.DetectMagic)))