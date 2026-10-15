-- Trigger: bigby_assistant_relocate
-- Zone: 30, ID: 94
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3094

-- Converted from DG Script #3094: bigby_assistant_relocate
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"lost"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("relocate_spell_quest") < 1 then
    if actor.level >=65 then
        if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" then
            self:say("Yes, one of our research mages.")
            wait(1.5)
            self:command("sigh")
            self:say("She was researching a very powerful transportation spell.")
            wait(1.5)
            self:say("I believe Bigby called the spell 'Relocate'.")
            wait(1.5)
            self:say("But she hasn't returned yet. Can you please find her?")
            self:say("She mentioned going to a dark desert to find something.")
            self:say("But that is all I know. I'm sorry I can not help more.")
            self:say("Please find her!")
        else
            self:say("I'm sorry but this doesn't concern you. Bigby would be very upset.")
            self:command("shake")
        end
    else
        self:say("I'm sorry young one, but I don't think you can help just yet.")
        self:command("pat " .. tostring(actor.name))
    end
else
    self:say("Yes Yes, I heard that you found her! Please bring her back safely.")
end