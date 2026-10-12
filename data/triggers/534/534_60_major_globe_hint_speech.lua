-- Trigger: major_globe_hint_speech
-- Zone: 534, ID: 60
-- Type: MOB, Flags: GLOBAL, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53460

-- Converted from DG Script #53460: major_globe_hint_speech
-- Original: MOB trigger, flags: GLOBAL, SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gone?", "gone", "while?", "while", "rascal?", "rascal", "lirne?", "lirne"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send(tostring(self.name) .. " says, 'Yeah, Lirne.  He disappeared a little while ago on a job in Frost Valley.'")
self:command("frown")
wait(2)
actor:send(tostring(self.name) .. " says, 'None of us have heard from him since.  I hope that ol' warmage hasn't gotten himself into more trouble than he can handle.'")