-- Trigger: phase_1_warrior_vambraces
-- Zone: 553, ID: 16
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55316

-- Converted from DG Script #55316: phase_1_warrior_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
        actor:send(tostring(self.name) .. " tells you, \"the warrior types but I'll need 3 quantities of some amber dust,\"")
        actor:send(tostring(self.name) .. " tells you, \"and a set of Rusted Vambraces. Return these things to me in\"")
        actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block