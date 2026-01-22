-- Trigger: Nukreth Spire goblin help speech
-- Zone: 462, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46216

-- Converted from DG Script #46216: Nukreth Spire goblin help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: treasure help yes okay what where
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "treasure") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "what") or string.find(string.lower(speech), "where")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path4") == 0 then
        self.room:send(tostring(self.name) .. " says, 'Yessss, had me a shiny treasure I did.  Hid it on some")
        self.room:send("</>bodies before they could eats 'em.  Or me.'")
        wait(1)
        self:say("Should still be up there in the larder.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(2)
        self.room:send(tostring(self.name) .. " hides himself out of sight.")
        self:command("hide")
        if not actor:get_quest_var("nukreth_spire:treasure") then
            actor:set_quest_var("nukreth_spire", "treasure", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end