-- Trigger: UNUSED
-- Zone: 520, ID: 53
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #52053

-- Converted from DG Script #52053: UNUSED
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: nevereverusethistriggerorIeatyouforbreakfast
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "nevereverusethistriggerorieatyouforbreakfast")) then
    return true  -- No matching keywords
end
self.room:spawn_object(520, 52)