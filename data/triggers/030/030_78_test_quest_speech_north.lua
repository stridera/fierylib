-- Trigger: test_quest_speech_north
-- Zone: 30, ID: 78
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3078

-- Converted from DG Script #3078: test_quest_speech_north
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"brother"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor:get_quest_stage("zzurs_funky_quest") == 1 then
        actor:send(tostring(self.name) .. " says to you, 'My brother is looking for me?'")
        actor:advance_quest("zzurs_funky_quest")
    else
    end
else
end