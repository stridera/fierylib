-- Trigger: hermit_speak1
-- Zone: 490, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49037

-- Converted from DG Script #49037: hermit_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trade?", "trade"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("griffin_quest") > 0 then
    self:command("sigh")
    self:say("The one thing that I miss from the life I used to lead is whisky.")
    wait(1)
    self:say("If you bring me a bottle of whisky, the ladder is yours.")
end