-- Trigger: phase_2_where
-- Zone: 556, ID: 4
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55604

-- Converted from DG Script #55604: phase_2_where
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 100 (DG word-list mode, not a probability)
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and'")
actor:send(tostring(self.name) .. " tells you, 'adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level 21 to 40, so'")
actor:send(tostring(self.name) .. " tells you, 'the items I desire can be found in areas of that'")
actor:send(tostring(self.name) .. " tells you, 'difficulty.  Once you have agreed to take on my'")
actor:send(tostring(self.name) .. " tells you, 'quests you can seek another like me for tasks a'")
actor:send(tostring(self.name) .. " tells you, 'bit more difficult.'")