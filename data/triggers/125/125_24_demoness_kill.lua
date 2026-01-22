-- Trigger: Demoness kill
-- Zone: 125, ID: 24
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12524

-- Converted from DG Script #12524: Demoness kill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: kill Kill
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "kill") or string.find(string.lower(speech), "kill")) then
    return true  -- No matching keywords
end
wait(1)
self.room:send(tostring(self.name) .. " says, 'Well, yes.  The master likes his peace...  You will disturb")
self.room:send("</>his peace.'")
wait(1)
actor:send(tostring(self.name) .. " glares at you.")
self.room:send_except(actor, tostring(self.name) .. " glares at " .. tostring(actor.name) .. ".")