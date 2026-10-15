-- Trigger: infidel_speak2
-- Zone: 480, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48022

-- Converted from DG Script #48022: infidel_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"challenge?", "challenge"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Yes, challenge.  I presume you have been sent by that young upstart.")
self:command("spit")
wait(0.1)
self:say("If you haven't, then you had better leave before my patience wears thin.")
self:command("ponder")
wait(0.1)
self:say("And if you have, then you'd better leave before I kill you.")
self:command("pat " .. tostring(actor.name))
self:say("Run along now little one.")