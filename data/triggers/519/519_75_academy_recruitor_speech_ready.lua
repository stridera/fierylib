-- Trigger: academy_recruitor_speech_ready
-- Zone: 519, ID: 75
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51975

-- Converted from DG Script #51975: academy_recruitor_speech_ready
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"ready"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("school") == 1 then
    wait(0.2)
    self:command("unlock gates")
    self:command("open gates")
    actor:send(tostring(self.name) .. " tells you, 'Your first lesson is with the Instructor of Adventure.'")
    actor:send(tostring(self.name) .. " escorts you into the Academy.")
    actor:send(tostring(self.name) .. " tells you, 'You can say <magenta>EXIT</> at any time to leave.'")
    wait(2)
    actor:move("east")
    self:command("close gates")
    self:command("lock gates")
end