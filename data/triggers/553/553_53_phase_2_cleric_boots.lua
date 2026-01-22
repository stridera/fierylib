-- Trigger: phase_2_cleric_boots
-- Zone: 553, ID: 53
-- Type: MOB, Flags: SPEECH_TO
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: >= 2
--
-- Original DG Script: #55353

-- Converted from DG Script #55353: phase_2_cleric_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 21 then
    -- UNCONVERTED: >= 2
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"cleric types but I'll need 3 uncut opals, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Crushed Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end