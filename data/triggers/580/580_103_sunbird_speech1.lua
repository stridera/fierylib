-- Trigger: Sunbird_speech1
-- Zone: 580, ID: 103
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- When asked about Kannon, the Sunbird performs the cinematic light
-- show then explains that the goddess's power has waned.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"kannon", "kannon?", "who?", "who", "goddess", "goddes?", "goddes", "mercy", "mercy?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(7)
self:say("Through her holy benevolence, I once protected this entire island.")
self.room:send("The Sunbird spreads its wings and begins to radiate a <b:white>glowing</> <b:yellow>l</><b:white>i<b:yellow>g</><b:white>h</><b:yellow>t.</>")
wait(15)
self.room:send("<b:white>The light grows...</>")
wait(15)
self.room:send("The light suddenly <b:white>FL</><b:yellow>AR</><b:white>ES!</>")
wait(7)
self.room:send("The Sunbird falters and stumbles before the altar.")
wait(8)
self:say("But now her divine presence has waned")
self:say("Now I can only shelter this small space near her shrine.")
self:say("I fear something terrible has happened to her...")