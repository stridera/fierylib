-- Trigger: Phase_2_diabolist_accept
-- Zone: 553, ID: 62
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55362

-- Converted from DG Script #55362: Phase_2_diabolist_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
if actor.class == "diabolist" then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 1 then
        actor.name:advance_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice <b:white>boots</>, a <b:white>helm</>, <b:white>gauntlets</>,\"")
    actor:send(tostring(self.name) .. " tells you, \"<b:white>vambraces</>, <b:white>greaves</>, <b:white>chestguard</>, and a <b:white>bracer</>.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Remember, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for diabolists only.\"")
end