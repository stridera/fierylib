-- Trigger: give_stew
-- Zone: 200, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20010

-- Converted from DG Script #20010: give_stew
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
self:command("nod")
self.room:spawn_object(200, 45)
self:command("give bowl " .. tostring(actor.name))