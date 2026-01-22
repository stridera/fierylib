-- Trigger: Phase_2_ranger_accept
-- Zone: 554, ID: 12
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55412

-- Converted from DG Script #55412: Phase_2_ranger_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if actor.class == "ranger" then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 1 then
        actor.name:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice <b:white>boots</>, a <b:white>cap</>, <b:white>gloves</>,\"")
    actor:send(tostring(self.name) .. " tells you, \"<b:white>sleeves</>, <b:white>pants</>, <b:white>jerkin</>, and a <b:white>bracer</>.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for rangers only.\"")
end