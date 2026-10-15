-- Trigger: Wise leprechaun discusses spiders
-- Zone: 615, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61537

-- Converted from DG Script #61537: Wise leprechaun discusses spiders
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"spiders", "spiders?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
self:say("They've been terrorizing us for a long time now.")
self:say("But I know how to defeat their webs.")
wait(3)
self:command("ponder")
wait(2)
self:say("I suppose I could help you... if you give me a cherry!")
self:say("And if you do, I'll enchant a knife if you want.")
self:say("Of course, only one of these flint knives will do the trick.")