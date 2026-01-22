-- Trigger: Phase_3_diabolist_accept
-- Zone: 554, ID: 72
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55472

-- Converted from DG Script #55472: Phase_3_diabolist_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if actor.class == "diabolist" then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 2 then
        actor.name:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice boots, a helm, gauntlets,\"")
    actor:send(tostring(self.name) .. " tells you, \"vambraces, greaves, chestguard, and a bracer.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me status at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for diabolists only.\"")
end