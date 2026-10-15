-- Trigger: prince_speak1
-- Zone: 480, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48010

-- Converted from DG Script #48010: prince_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trade?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 and actor.level > 80 then
    wait(0.2)
    self:say("If you bring me the head of the king's dark champion, then I will give you an item that may help you in your battle with the king.")
    wait(0.1)
    self:say("According to our rules of dueling, you must say 'the prince wishes to challenge you by proxy', before starting the fight.")
    wait(0.1)
    self:command("smile")
    self:say("That way, I can claim the victory as my own.")
end