-- Trigger: Diplomat responds to 'yes'
-- Zone: 502, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50209

-- Converted from DG Script #50209: Diplomat responds to 'yes'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(4)
self:command("smile")
self:say("Then we would forever be in your debt.")