-- Trigger: phase_1_rogue_greaves
-- Zone: 553, ID: 37
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55337

-- Converted from DG Script #55337: phase_1_rogue_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for rogues only
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"pants for the rogue types but I'll need 3 quantities of some\"")
    actor:send(tostring(self.name) .. " tells you, \"citrine dust, and a set of Rusted Leggings. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end