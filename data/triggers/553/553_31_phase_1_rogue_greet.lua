-- Trigger: phase_1_rogue_greet
-- Zone: 553, ID: 31
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55331

-- Converted from DG Script #55331: phase_1_rogue_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB then
    if actor:get_quest_stage("phase_armor") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some [<b:white>armor quests</>]?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end