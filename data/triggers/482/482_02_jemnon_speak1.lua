-- Trigger: jemnon_speak1
-- Zone: 482, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48202

-- Converted from DG Script #48202: jemnon_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(4)
if speech == "yes" then
    actor:send("Very inebriated, " .. tostring(self.name) .. " says, 'Then you come t' the right place!  Pull up a chair an' siddown!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Now, whaddya wan' kno 'bout??'")
else
    actor:send(tostring(self.name) .. " says, 'Well I dun wanna talk t' yous anyway!'")
    self:emote("crosses his arms in a huff and turns away.")
end