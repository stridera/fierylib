-- Trigger: LP2_bard_subclass_speech3
-- Zone: 43, ID: 62
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4362

-- Converted from DG Script #4362: LP2_bard_subclass_speech3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "I believe if I refuse to grow old I can stay young til I die") or string.find(speech, "I believe if I refuse to grow old, I can stay young til I die") then
    if actor:get_quest_stage("bard_subclass") == 5 then
        wait(1)
        self.room:send(tostring(self.name) .. " wipes a tear from his eye.")
        actor:send(tostring(self.name) .. " says, 'Yeah, that's a great one.'")
        wait(2)
        self:command("applaud " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'You did great kid, congratulations.  If you want a spot in the Guild, it's yours.  Here's your first spellbook and pen to commemorate the occassion.'")
        wait(1)
        self.room:spawn_object(10, 29)
        self:command("give spellbook " .. tostring(actor))
        self.room:spawn_object(10, 30)
        self:command("give quill " .. tostring(actor))
        actor:complete_quest("bard_subclass")
        actor:send("Type '<b:magenta>subclass</>' to proceed.")
    end
end