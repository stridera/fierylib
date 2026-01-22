-- Trigger: priestess_speech2
-- Zone: 123, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12302

-- Converted from DG Script #12302: priestess_speech2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: great rite
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "great") or string.find(string.lower(speech), "rite")) then
    return true  -- No matching keywords
end
if string.find(speech, "GREAT") RITE OF INVOCATION? or string.find(speech, "GREAT") RITE? or string.find(speech, "GREAT") RITE OF INVOCATION or string.find(speech, "GREAT") RITE then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'For generations, our coven has scoured the face of Ethilien to find a place where the touch of the <b:cyan>Old Gods</> might still be found.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Performed correctly, this ritual will allow us to call to our Goddess in the Dreaming and provide a bridge across space and time back into the mortal realm.'")
end