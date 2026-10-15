-- Trigger: foe?
-- Zone: 200, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20004

-- Converted from DG Script #20004: foe?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"foe"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Then we are on the same side.")
wait(0.1)
self:command("grin")
self:say("When you come to the guard tell him 'I am an enemy of Ruin Wormheart")
self:say("and he will not bother you.")
self:command("wave")
actor:move("e")