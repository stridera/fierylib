-- Trigger: phase_1_warrior_plate
-- Zone: 553, ID: 18
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55318

-- Converted from DG Script #55318: phase_1_warrior_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the warriors but\"")
        actor:send(tostring(self.name) .. " tells you, \"I'll need 3 crushed emeralds, and a Rusted Plate. Return these\"")
        actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block