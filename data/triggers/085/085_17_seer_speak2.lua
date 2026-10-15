-- Trigger: seer_speak2
-- Zone: 85, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8517

-- Converted from DG Script #8517: seer_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"riddle?", "riddle"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Yes.  Very well.")
self:command("grin")
wait(0.1)
self:say("The riddle:")
self.room:send("Two bodies have I,")
self.room:send("Though both joined in one.")
self.room:send("The more still I stand,")
self.room:send("The quicker I run.")
wait(0.1)
self:say("What am I?")