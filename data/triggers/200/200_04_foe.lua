-- Trigger: foe?
-- Zone: 200, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20004

-- Converted from DG Script #20004: foe?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: foe
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "foe")) then
    return true  -- No matching keywords
end
self:say("Then we are on the same side.")
wait(1)
self:command("grin")
self:say("When you come to the guard tell him 'I am an enemy of Ruin Wormheart")
self:say("and he will not bother you.")
self:command("wave")
actor.name:move("e")