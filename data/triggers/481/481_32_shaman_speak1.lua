-- Trigger: shaman_speak1
-- Zone: 481, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48132

-- Converted from DG Script #48132: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"son?", "son", "warlord?", "warlord"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self:command("sigh")
self.room:send(tostring(self.name) .. " says, 'Yes, I remember the boy.  Small and pale skinned for his tribe, but he was fast enough when he got the chance to escape.  I was distracted for a second by Vulcera's pet and he nipped into the volcano I had opened.'")
self:command("fume")
wait(1)
self.room:send(tostring(self.name) .. " says, 'I think the volcano god is getting angry now for lack of blood.  Will you help us?'")