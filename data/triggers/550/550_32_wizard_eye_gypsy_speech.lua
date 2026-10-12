-- Trigger: wizard_eye_gypsy_speech
-- Zone: 550, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55032

-- Converted from DG Script #55032: wizard_eye_gypsy_speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wizard", "eye", "wizard?", "eye?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_quest_stage("wizard_eye") == 1 then
    actor:send(tostring(self.name) .. " says, 'Why yes, I can help with that!  So you want your own crystal ball, ya say?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Show</> me your <b:cyan>palm</>.'")
end