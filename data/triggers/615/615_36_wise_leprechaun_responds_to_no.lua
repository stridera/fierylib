-- Trigger: Wise leprechaun responds to 'no'
-- Zone: 615, ID: 36
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61536

-- Converted from DG Script #61536: Wise leprechaun responds to 'no'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    if actor.gender == "female" then
        self:say("Well skedaddle off and fetch some then, won't you lass?")
    else
        self:say("Well skedaddle off and fetch some then, won't you laddie?")
    end
end