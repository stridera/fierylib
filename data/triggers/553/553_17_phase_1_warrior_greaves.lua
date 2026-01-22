-- Trigger: phase_1_warrior_greaves
-- Zone: 553, ID: 17
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55317

-- Converted from DG Script #55317: phase_1_warrior_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
        actor:send(tostring(self.name) .. " tells you, \"greaves for the warrior types but I'll need 3 quantities of some\"")
        actor:send(tostring(self.name) .. " tells you, \"aquamarine dust, and a set of Rusted Greaves. Return these things\"")
        actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block