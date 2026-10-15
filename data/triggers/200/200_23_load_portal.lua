-- Trigger: load _portal
-- Zone: 200, ID: 23
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20023

-- Converted from DG Script #20023: load _portal
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yix'xyua"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send("The giant obsidian statue makes a magical gesture and a large black portal erupts from the ground!")
self.room:spawn_object(200, 49)
self.room:send("A giant obsidian statue says, 'When you want to leave just say exit.'")