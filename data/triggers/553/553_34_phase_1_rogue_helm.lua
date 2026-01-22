-- Trigger: phase_1_rogue_helm
-- Zone: 553, ID: 34
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55334

-- Converted from DG Script #55334: phase_1_rogue_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for rogues only
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Headgear ya ask? Well now I can make a nice chain coif for the rogue types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 quantities of some amythest dust, and a Rusted Coif.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end