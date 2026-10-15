-- Trigger: shaman_speak2
-- Zone: 178, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17802

-- Converted from DG Script #17802: shaman_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "fear?", "fear"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("This is no easy test, and many have failed.")
self:command("sigh")
wait(1)
self:say("My last student still hasn't returned, but I know he is not yet dead.")
self:command("consider " .. tostring(actor.name))
if actor.level < 18 then
    self:say("I strongly suggest that you do not attempt this test yet.")
    wait(1)
end
self:say("If you are certain you wish to continue, then say \"Master let the test begin\".")