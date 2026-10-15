-- Trigger: assistant_for?
-- Zone: 200, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20027

-- Converted from DG Script #20027: assistant_for?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"for?", "for"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Yes for.")
self:command("sigh")
wait(0.1)
self.room:send("Yix'Xyua whispers something to the assistant.")
self:say("Have you come here to assist us in our problem with Ruin Wormheart?")