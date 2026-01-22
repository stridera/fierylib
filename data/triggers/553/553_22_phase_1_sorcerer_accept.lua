-- Trigger: Phase_1_sorcerer_accept
-- Zone: 553, ID: 22
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55322

-- Converted from DG Script #55322: Phase_1_sorcerer_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 0 then
        actor.name:start_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice [<b:white>sandals</>], a [<b:white>turban</>], [<b:white>gloves</>],\"")
    actor:send(tostring(self.name) .. " tells you, \"[<b:white>sleeves</>], [<b:white>pants</>], [<b:white>tunic</>], and a [<b:white>bracelet</>].\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Also, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for sorcerers only.\"")
end