-- Trigger: Phase_1_cleric_accept
-- Zone: 553, ID: 3
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55303

-- Converted from DG Script #55303: Phase_1_cleric_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a cleric and set the quest variable for later interaction.
-- 
-- This is for clerics only
local CLERIC_SUB = (actor.class == cleric  or  actor.class == priest  or  actor.class == diabolist  or  actor.class == druid)
if CLERIC_SUB then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 0 then
        actor.name:start_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice [<b:white>boots</>], a [<b:white>helm</>], [<b:white>gauntlets</>],\"")
    actor:send(tostring(self.name) .. " tells you, \"[<b:white>vambraces</>], [<b:white>greaves</>], [<b:white>plate</>], and a [<b:white>bracer</>].\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Also, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for clerics only.\"")
end