-- Trigger: seer_speak2
-- Zone: 85, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8517

-- Converted from DG Script #8517: seer_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: riddle?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "riddle?")) then
    return true  -- No matching keywords
end
self:say("Yes.  Very well.")
self:command("grin")
wait(1)
self:say("The riddle:")
self.room:send("Two bodies have I,")
self.room:send("Though both joined in one.")
self.room:send("The more still I stand,")
self.room:send("The quicker I run.")
wait(1)
self:say("What am I?")