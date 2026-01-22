-- Trigger: Phase_2_monk_accept
-- Zone: 553, ID: 82
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55382

-- Converted from DG Script #55382: Phase_2_monk_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if actor.class == "monk" then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 1 then
        actor.name:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice <b:white>boots</>, a <b:white>cap</>, <b:white>fistwraps</>,\"")
    actor:send(tostring(self.name) .. " tells you, \"<b:white>sleeves</>, <b:white>leggings</>, <b:white>tunic</>, and a <b:white>bracer</>.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for monks only.\"")
end