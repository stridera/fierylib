-- Trigger: academy_recruitor_speech_ready
-- Zone: 519, ID: 75
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51975

-- Converted from DG Script #51975: academy_recruitor_speech_ready
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: ready
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ready")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("school") == 1 then
    wait(2)
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