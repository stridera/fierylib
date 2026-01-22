-- Trigger: phase_1_warrior_bracer
-- Zone: 553, ID: 19
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55319

-- Converted from DG Script #55319: phase_1_warrior_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
        actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 crushed citrines, and a Rusted Plate\"")
        actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
        actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block