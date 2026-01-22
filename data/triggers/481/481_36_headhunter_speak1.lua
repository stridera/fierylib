-- Trigger: headhunter_speak1
-- Zone: 481, ID: 36
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48136

-- Converted from DG Script #48136: headhunter_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: son? warlord?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "son?") or string.find(string.lower(speech), "warlord?")) then
    return true  -- No matching keywords
end
wait(2)
self:emote("throws his head back and laughs heartily.")
self:command("ponder " .. tostring(actor.name))
self.room:send(tostring(self.name) .. " says, 'That wimp who dares to call himself a warlord sent you, did he?  Well you won't find his son here.'")
wait(2)
self:command("smirk")
self.room:send(tostring(self.name) .. " says, 'We gave him to the shaman for a sacrifice to the volcano god.'")
wait(2)
self:emote("looks thoughtful.")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Although, the god does not seem to have been appeased yet, perhaps we need another candidate.'")
self:command("poke " .. tostring(actor.name))