-- Trigger: captain_guard_speak1
-- Zone: 86, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8602

-- Converted from DG Script #8602: captain_guard_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: foe foe?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "foe") or string.find(string.lower(speech), "foe?")) then
    return true  -- No matching keywords
end
self:say("That is unacceptable!")
wait(1)
combat.engage(self, actor.name)