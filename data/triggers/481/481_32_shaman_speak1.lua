-- Trigger: shaman_speak1
-- Zone: 481, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48132

-- Converted from DG Script #48132: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: son? warlord?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "son?") or string.find(string.lower(speech), "warlord?")) then
    return true  -- No matching keywords
end
wait(2)
self:command("sigh")
self.room:send(tostring(self.name) .. " says, 'Yes, I remember the boy.  Small and pale skinned for his tribe, but he was fast enough when he got the chance to escape.  I was distracted for a second by Vulcera's pet and he nipped into the volcano I had opened.'")
self:command("fume")
wait(1)
self.room:send(tostring(self.name) .. " says, 'I think the volcano god is getting angry now for lack of blood.  Will you help us?'")