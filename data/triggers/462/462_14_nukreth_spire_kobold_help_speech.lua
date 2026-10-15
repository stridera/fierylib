-- Trigger: Nukreth Spire kobold help speech
-- Zone: 462, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46214

-- Converted from DG Script #46214: Nukreth Spire kobold help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"baby", "help", "yes", "okay", "what", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path2") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'I hid an egg in the corner animal pen.  It should still")
        self.room:send("</>be there.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(0.2)
        self.room:send(tostring(self.name) .. " hides herself out of sight.")
        self:command("hide")
        if (actor:get_quest_var("nukreth_spire:baby") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "baby", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end