-- Trigger: shaman_speak1
-- Zone: 481, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48134

-- Converted from DG Script #48134: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help?", "help", "aid?", "aid", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Vulcera has prevented us from making our customary sacrifices by placing one of her...'")
wait(0.2)
self:command("ponder")
wait(0.2)
self.room:send(tostring(self.name) .. " says, '\"pets\" in our sacred area before the volcano, and I fear that if we do not make a sacrifice soon...'")
wait(1)
self:command("shrug")
self:say("Well, the volcano will most likely blow up the island.")
self:command("sigh")
wait(1)
self.room:send(tostring(self.name) .. " says, 'If you can bring me the dragon head of the chimera, then I can reward you richly.'")
self:command("wink " .. tostring(actor.name))