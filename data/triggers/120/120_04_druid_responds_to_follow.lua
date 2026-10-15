-- Trigger: Druid responds to 'follow'
-- Zone: 120, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12004

-- Converted from DG Script #12004: Druid responds to 'follow'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"follow"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("twisted_sorrow") == 1 then
    wait(0.4)
    self:emote("nods solemnly.")
    wait(0.8)
    self:follow(actor)
end