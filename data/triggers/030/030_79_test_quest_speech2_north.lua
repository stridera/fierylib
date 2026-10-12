-- Trigger: test_quest_speech2_north
-- Zone: 30, ID: 79
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3079

-- Converted from DG Script #3079: test_quest_speech2_north
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor:get_quest_stage("zzurs_funky_quest") == 2 then
        actor:send(tostring(self.name) .. " says to you, 'I would love to send him proof of my doings but I am so busy.'")
        self:command("sigh")
        actor:send(tostring(self.name) .. " says to you, 'I need a diadem of bone.'")
        actor:advance_quest("zzurs_funky_quest")
    else
    end
else
end