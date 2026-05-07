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
if not string.find(speech_lower, "foe") then
    return true  -- No matching keywords
end
self:say("That is unacceptable!")
wait(1)
-- TODO: combat.engage expects an entity (target), not a name string; verify actor is the correct target
combat.engage(actor)