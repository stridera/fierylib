-- Trigger: warlord_speak1
-- Zone: 481, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48129

-- Converted from DG Script #48129: warlord_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"son?", "son"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Yes, he was kidnapped by the Bone Tribe head-hunters for a sacrifice.'")
wait(1)
self:command("spit")
self.room:send(tostring(self.name) .. " says, 'Those headhunters are scum, and their chief is the worst of them.  If only I had warriors to spare, I could attack and kill him.'")
self:command("glare")
wait(1)
self.room:send(tostring(self.name) .. " says, 'He carries my father's shriveled head on his belt, and now he has taken my son too.'")