-- Trigger: test_quest_banter1
-- Zone: 30, ID: 76
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3076

-- Converted from DG Script #3076: test_quest_banter1
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello", "howdy", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not actor:get_has_completed("zzurs_funky_quest") then
    self:say("I wonder if my brother the Northern road ranger is still alive?")
    self:command("sigh")
    self:say("If only I had some proof of his doings.")
    self:say("Will you help me?")
else
end