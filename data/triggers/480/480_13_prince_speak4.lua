-- Trigger: prince_speak4
-- Zone: 480, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48013

-- Converted from DG Script #48013: prince_speak4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 349 then
    wait(0.2)
    self:command("sigh")
    self:say("Many years ago when King Ureal threatened the land, I swore that I would try to stop him.")
    wait(0.1)
    self:say("I was the paladin champion, and it was my duty to bring an end to his evil.")
    wait(0.1)
    self:emote("sighs again loudly.")
    self:say("But I failed.")
end