-- Trigger: Phase_3_rogue_accept
-- Zone: 555, ID: 42
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55542

-- Converted from DG Script #55542: Phase_3_rogue_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 2 then
        actor.name:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice boots, a cap, gloves,\"")
    actor:send(tostring(self.name) .. " tells you, \"sleeves, leggings, tunic, and a bracer.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me status at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for rogues only.\"")
end