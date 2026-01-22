-- Trigger: Knight_Champ_speech5
-- Zone: 550, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55014

-- Converted from DG Script #55014: Knight_Champ_speech5
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: prove
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "prove")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
actor:send("The Knight Champion whispers to you 'Yes prove you are worthy of honour and")
actor:send("</>respect.'")
self:command("think")
wait(1)
actor:send("The Knight Champion whispers to you 'Perhaps win a great victory over a great")
actor:send("</>evil.'")