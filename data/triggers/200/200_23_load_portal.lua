-- Trigger: load _portal
-- Zone: 200, ID: 23
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20023

-- Converted from DG Script #20023: load _portal
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Yix'Xyua
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yix'xyua")) then
    return true  -- No matching keywords
end
self.room:send("The giant obsidian statue makes a magical gesture and a large black portal erupts from the ground!")
self.room:spawn_object(200, 49)
self.room:send("a giant obsidian statue says, 'When you want to leave just say exit.'")