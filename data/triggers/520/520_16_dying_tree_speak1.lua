-- Trigger: dying_tree_speak1
-- Zone: 520, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #52016

-- Converted from DG Script #52016: dying_tree_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help?", "help", "hydra?", "hydra"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("sigh")
self.room:send(tostring(self.name) .. " says, 'I was the Tree of Life, and now I live in agony")
self.room:send("</>thanks to the Hydra's fire.  Kill me, and take a branch to help you kill the")
self.room:send("</>Hydra.'")