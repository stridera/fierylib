-- Trigger: major_globe_hint_speech
-- Zone: 534, ID: 60
-- Type: MOB, Flags: GLOBAL, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53460

-- Converted from DG Script #53460: major_globe_hint_speech
-- Original: MOB trigger, flags: GLOBAL, SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: gone? gone while? while rascal? rascal lirne? lirne
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "gone?") or string.find(string.lower(speech), "gone") or string.find(string.lower(speech), "while?") or string.find(string.lower(speech), "while") or string.find(string.lower(speech), "rascal?") or string.find(string.lower(speech), "rascal") or string.find(string.lower(speech), "lirne?") or string.find(string.lower(speech), "lirne")) then
    return true  -- No matching keywords
end
wait(2)
actor:send(tostring(self.name) .. " says, 'Yeah, Lirne.  He disappeared a little while ago on a job in Frost Valley.'")
self:command("frown")
wait(2)
actor:send(tostring(self.name) .. " says, 'None of us have heard from him since.  I hope that ol' warmage hasn't gotten himself into more trouble than he can handle.'")