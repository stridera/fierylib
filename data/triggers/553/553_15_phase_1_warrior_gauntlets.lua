-- Trigger: phase_1_warrior_gauntlets
-- Zone: 553, ID: 15
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55315

-- Converted from DG Script #55315: phase_1_warrior_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
        actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 crushed amethysts, and a set of\"")
        actor:send(tostring(self.name) .. " tells you, \"Rusted Gauntlets. Return these things to me in any order at\"")
        actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block