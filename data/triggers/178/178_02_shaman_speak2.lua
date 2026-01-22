-- Trigger: shaman_speak2
-- Zone: 178, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17802

-- Converted from DG Script #17802: shaman_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes fear?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "fear?")) then
    return true  -- No matching keywords
end
self:say("This is no easy test, and many have failed.")
self:command("sigh")
wait(1)
self:say("My last student still hasn't returned, but I know he is not yet dead.")
self:command("consider " .. tostring(actor.name))
if actor.level < 18 then
    self:say("I strongly suggest that you do not attempt this test yet.")
    wait(1)
end
self:say("If you are certain you wish to continue, then say \"Master let the test begin\".")