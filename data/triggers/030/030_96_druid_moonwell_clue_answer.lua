-- Trigger: druid_moonwell_clue_answer
-- Zone: 30, ID: 96
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3096

-- Converted from DG Script #3096: druid_moonwell_clue_answer
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"punished"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.class == "druid" then
    if actor.level >= 73 then
        wait(1.5)
        self:say("Yes, yes, but hopefully one day she'll be able to leave that tree.")
        wait(1.5)
    else
        wait(1.5)
        self:say("I'm sorry, but you are still too young.")
        wait(0.5)
        self:command("smile " .. tostring(actor.name))
        self:command("ruffle " .. tostring(actor.name))
    end
else
    self:say("I'm sorry, but it's okay.  Don't worry about it.")
    self:command("smile " .. tostring(actor.name))
end