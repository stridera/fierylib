-- Trigger: phase_1_cleric_greet
-- Zone: 553, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55302

-- Converted from DG Script #55302: phase_1_cleric_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is for clerics only
local CLERIC_SUB = (actor.class == cleric  or  actor.class == priest  or  actor.class == diabolist  or  actor.class == druid)
if CLERIC_SUB then
    if actor:get_quest_stage("phase_armor") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some [<b:white>armor quests</>]?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end