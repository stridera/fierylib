-- Trigger: Nukreth Spire kobold help speech
-- Zone: 462, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46214

-- Converted from DG Script #46214: Nukreth Spire kobold help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: baby help yes okay what where
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "baby") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "what") or string.find(string.lower(speech), "where")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path2") == 0 then
        self.room:send(tostring(self.name) .. " says, 'I hid an egg in the corner animal pen.  It should still")
        self.room:send("</>be there.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(2)
        self.room:send(tostring(self.name) .. " hides herself out of sight.")
        self:command("hide")
        if not actor:get_quest_var("nukreth_spire:baby") then
            actor:set_quest_var("nukreth_spire", "baby", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end