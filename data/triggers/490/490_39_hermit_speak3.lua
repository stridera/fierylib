-- Trigger: hermit_speak3
-- Zone: 490, ID: 39
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49039

-- Converted from DG Script #49039: hermit_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"marvin", "marvin?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("griffin_quest") > 0 then
    self:command("sigh")
    self:say("Ah, the St. Marvin was lost with all hands many years ago.  They say the wreck has never been found.")
    self:command("peer")
    wait(1)
    self:say("I can guess where it is though, but you will need a ladder to get to it.")
end