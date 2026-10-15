-- Trigger: vulcera_speak2
-- Zone: 481, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48122

-- Converted from DG Script #48122: vulcera_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"punishment", "punishment?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self:emote("sighs loudly.")
self.room:send(tostring(self.name) .. " says, 'Many years ago, I fell in love with a mortal man who wanted to wed me, but Lokari found out.'")
self:emote("grimaces.")
wait(1)
self.room:send(tostring(self.name) .. " says, 'He was very jealous.  Even though I saw him as a father, he must have felt something more.'")
wait(1)
self.room:send(tostring(self.name) .. " says, 'I haven't seen my fiance since, although Lokari swore that he did not kill him, and gave him the key to this chest should he ever return to claim me.'")
wait(1)
self.room:send(tostring(self.name) .. " says, 'In this chest is the ring he gave me to proclaim his love, which Lokari left as a reminder of how fickle mortals can be.'")
self:command("shrug")
wait(1)
self.room:send(tostring(self.name) .. " says, 'After all, if he really loved me, he would return and open the chest.'")
self:emote("sighs again.")
wait(1)
self:say("If only someone could give me the key to the chest.")