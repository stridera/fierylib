-- Trigger: headhunter_speak1
-- Zone: 481, ID: 36
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48136

-- Converted from DG Script #48136: headhunter_speak1
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
self:emote("throws his head back and laughs heartily.")
self:command("ponder " .. tostring(actor.name))
self.room:send(tostring(self.name) .. " says, 'That wimp who dares to call himself a warlord sent you, did he?  Well you won't find his son here.'")
wait(0.2)
self:command("smirk")
self.room:send(tostring(self.name) .. " says, 'We gave him to the shaman for a sacrifice to the volcano god.'")
wait(0.2)
self:emote("looks thoughtful.")
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Although, the god does not seem to have been appeased yet, perhaps we need another candidate.'")
self:command("poke " .. tostring(actor.name))