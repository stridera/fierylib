-- Trigger: Nukreth Spire goblin help speech
-- Zone: 462, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46216

-- Converted from DG Script #46216: Nukreth Spire goblin help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"treasure", "help", "yes", "okay", "what", "where"}) do
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
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'Yessss, had me a shiny treasure I did.  Hid it on some")
        self.room:send("</>bodies before they could eats 'em.  Or me.'")
        wait(1)
        self:say("Should still be up there in the larder.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(0.2)
        self.room:send(tostring(self.name) .. " hides himself out of sight.")
        self:command("hide")
        if (actor:get_quest_var("nukreth_spire:treasure") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "treasure", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end