-- Trigger: priestess_speech2
-- Zone: 123, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12302

-- Converted from DG Script #12302: priestess_speech2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: great rite (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "great rite", 1, true) then
    return true  -- Not the phrase
end
-- (the converter compared against upper-case text; `speech` is lower-case)
if string.find(speech, "great rite", 1, true) then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'For generations, our coven has scoured the face of Ethilien to find a place where the touch of the <b:cyan>Old Gods</> might still be found.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Performed correctly, this ritual will allow us to call to our Goddess in the Dreaming and provide a bridge across space and time back into the mortal realm.'")
end