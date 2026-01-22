-- Trigger: woman_yes
-- Zone: 200, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20016

-- Converted from DG Script #20016: woman_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes nods ok
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "nods") or string.find(string.lower(speech), "ok")) then
    return true  -- No matching keywords
end
self:command("smile " .. tostring(actor.name))
wait(1)
self:say("There is a guard to the north that is blocking the way to my escape.")
self:say("I need you to go kill him and bring back his axe,")
self:say("so i have proof you have killed him.")
self:say("Go now.")
actor.name:move("n")
self:command("vis")