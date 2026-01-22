-- Trigger: Unicorn girl speech
-- Zone: 584, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58402

-- Converted from DG Script #58402: Unicorn girl speech
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: wrong
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wrong")) then
    return true  -- No matching keywords
end
wait(1)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'The King will not free me, even though my obligation of service to him is done.  He shall never have my hand in marriage, thus I shall remain his slave forever.'")