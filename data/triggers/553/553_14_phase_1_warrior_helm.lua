-- Trigger: phase_1_warrior_helm
-- Zone: 553, ID: 14
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55314

-- Converted from DG Script #55314: phase_1_warrior_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the warrior types\"")
        actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 quantities of some jade dust, and a Rusted\"")
        actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
        actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block