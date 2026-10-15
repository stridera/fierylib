-- Trigger: jemnon_speak1
-- Zone: 481, ID: 102
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48202

-- Converted from DG Script #48202: jemnon_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
if speech == "yes" then
    actor:send("Very inebriated, " .. tostring(self.name) .. " says, 'Then you come t' the right place!  Pull up a chair an' siddown!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Now, whaddya wan' kno 'bout??'")
else
    actor:send(tostring(self.name) .. " says, 'Well I dun wanna talk t' yous anyway!'")
    self:emote("crosses his arms in a huff and turns away.")
end