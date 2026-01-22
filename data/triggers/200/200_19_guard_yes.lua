-- Trigger: guard_yes
-- Zone: 200, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20019

-- Converted from DG Script #20019: guard_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
self:command("nod")
self:say("Tell the prior 'I must see the abbot.")
self.room:spawn_object(200, 42)
self:command("give key " .. tostring(actor.name))
self:command("bow")