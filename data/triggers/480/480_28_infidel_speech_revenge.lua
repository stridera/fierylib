-- Trigger: Infidel speech revenge
-- Zone: 480, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48028

-- Converted from DG Script #48028: Infidel speech revenge
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"revenge?", "revenge"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment < -349 then
    wait(0.2)
    self:command("grin")
    self:say("Many centuries ago, I was the champion of King Ureal, the mighty sorcerer who would conquer Ethilien.")
    wait(0.1)
    self:say("Some pathetic paladin sought to slay our King, claiming it was his duty to bring an end to his reign.")
    wait(0.1)
    self:say("He challenged me to a duel.")
    self:command("chuckle")
    wait(0.1)
    self:say("And lost.")
end