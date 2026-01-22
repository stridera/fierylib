-- Trigger: test
-- Zone: 188, ID: 83
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: eval %speech%
--
-- Original DG Script: #18883

-- Converted from DG Script #18883: test
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: eval
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "eval")) then
    return true  -- No matching keywords
end
if string.find(XXspeech, "XXeval") then
    -- UNCONVERTED: eval %speech%
    self.room:send(tostring(eval))
end