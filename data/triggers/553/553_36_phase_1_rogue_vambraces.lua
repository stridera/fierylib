-- Trigger: phase_1_rogue_vambraces
-- Zone: 553, ID: 36
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55336

-- Converted from DG Script #55336: phase_1_rogue_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for rogues only
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sleeves ya ask? Well now I can make a fine set of sleeves for\"")
    actor:send(tostring(self.name) .. " tells you, \"the rogue types but I'll need 3 crushed sapphires,\"")
    actor:send(tostring(self.name) .. " tells you, \"and a set of Rusted Sleeves. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end